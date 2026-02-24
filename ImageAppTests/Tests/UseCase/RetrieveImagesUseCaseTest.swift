//
//  RetrieveImagesUseCaseTest.swift
//  ImageApp
//
//  Created by Adonys Rauda on 23/2/26.
//

import XCTest
@testable import ImageApp

@MainActor
final class RetrieveImagesUseCaseTest: XCTestCase {
    private var sut: RetrieveImagesUseCase!
    private var mockRepository: MockImageRepository!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        mockRepository = .init()
        sut = .init(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeImageModel(id: String = "1") -> ImageModel {
        let url = UrlModel(regular: "https://example.com/regular",
                           full: "https://example.com/full",
                           small: "https://example.com/small",
                           medium: "https://example.com/medium")
        let user = UserModel(id: "u1",
                             username: "user1",
                             name: "User One",
                             profileImage: url,
                             totalLikes: 10,
                             totalPhotos: 5,
                             totalCollections: 2,
                             location: "Madrid",
                             bio: "Bio test")
        return ImageModel(id: id,
                          likes: 42,
                          urls: url,
                          user: user,
                          desc: "Test description",
                          createdAt: "2026-02-23")
    }

    // MARK: - Tests

    func testInvoke_Success() async throws {
        // GIVEN
        let request = ImagesRequest(page: 1, perPage: 10)
        let mockImage = makeImageModel(id: "1")
        mockRepository.stubbedResponse = [mockImage]

        // WHEN
        let result = try await sut.invoke(request: request)

        // THEN
        XCTAssertEqual(mockRepository.retrieveImagesCalledCount, 1)
        XCTAssertEqual(mockRepository.lastRequest?.page, request.page)
        XCTAssertEqual(mockRepository.lastRequest?.perPage, request.perPage)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, mockImage.id)
    }

    func testInvoke_Success_ReturnsAllImages() async throws {
        // GIVEN
        let request = ImagesRequest(page: 1, perPage: 10)
        let mockImages = (1...3).map { makeImageModel(id: "\($0)") }
        mockRepository.stubbedResponse = mockImages

        // WHEN
        let result = try await sut.invoke(request: request)

        // THEN
        XCTAssertEqual(mockRepository.retrieveImagesCalledCount, 1)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.map(\.id), ["1", "2", "3"])
    }

    func testInvoke_Success_EmptyList() async throws {
        // GIVEN
        let request = ImagesRequest(page: 1, perPage: 10)
        mockRepository.stubbedResponse = []

        // WHEN
        let result = try await sut.invoke(request: request)

        // THEN
        XCTAssertEqual(mockRepository.retrieveImagesCalledCount, 1)
        XCTAssertTrue(result.isEmpty)
    }

    func testInvoke_Failure_Unauthorized() async throws {
        // GIVEN
        let request = ImagesRequest(page: 1, perPage: 10)
        mockRepository.shouldFail = true
        mockRepository.customError = .unauthorized

        // WHEN
        do {
            let result = try await sut.invoke(request: request)
            XCTFail("Expected to throw, but got \(result)")
        } catch let error as DomainError {
            // THEN
            XCTAssertEqual(mockRepository.retrieveImagesCalledCount, 1)
            guard case .unauthorized = error else {
                XCTFail("Expected DomainError.unauthorized but got: \(error)")
                return
            }
        } catch {
            XCTFail("Expected DomainError but got: \(error)")
        }
    }

    func testInvoke_Failure_ServiceUnavailable() async throws {
        // GIVEN
        let request = ImagesRequest(page: 1, perPage: 10)
        mockRepository.shouldFail = true
        mockRepository.customError = .serviceUnavailable

        // WHEN
        do {
            let result = try await sut.invoke(request: request)
            XCTFail("Expected to throw, but got \(result)")
        } catch let error as DomainError {
            // THEN
            XCTAssertEqual(mockRepository.retrieveImagesCalledCount, 1)
            guard case .serviceUnavailable = error else {
                XCTFail("Expected DomainError.serviceUnavailable but got: \(error)")
                return
            }
        } catch {
            XCTFail("Expected DomainError but got: \(error)")
        }
    }

    func testInvoke_ForwardsRequestToRepository() async throws {
        // GIVEN — verifica que el request llega intacto al repository
        let request = ImagesRequest(page: 3, perPage: 20)
        mockRepository.stubbedResponse = []

        // WHEN
        _ = try await sut.invoke(request: request)

        // THEN
        XCTAssertEqual(mockRepository.lastRequest?.page, 3)
        XCTAssertEqual(mockRepository.lastRequest?.perPage, 20)
    }
}
