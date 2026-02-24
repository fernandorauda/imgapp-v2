//
//  ImageListViewModelTest.swift
//  ImageApp
//
//  Created by GitHub Copilot on 23/2/26.
//

import XCTest
@testable import ImageApp

@MainActor
final class ImageListViewModelTest: XCTestCase {
    private var sut: ImageListViewModel!
    private var mockUseCase: MockRetrieveImagesUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = .init()
        sut = .init(retrieveImagesUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

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

    func testRetrieveImages_Success() async {
        // GIVEN
        let mockImages = (1...2).map { makeImageModel(id: "\($0)") }
        mockUseCase.stubbedResponse = mockImages
        mockUseCase.shouldFail = false

        // WHEN
        await sut.retrieveImages()

        // THEN
        XCTAssertEqual(sut.images, mockImages)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(mockUseCase.invokeCallCount, 1)
    }

    func testRetrieveImages_Failure_Unauthorized() async {
        // GIVEN
        mockUseCase.shouldFail = true
        mockUseCase.customError = .unauthorized

        // WHEN
        await sut.retrieveImages()

        // THEN
        XCTAssertTrue(sut.images.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.currentError, .unauthorized)
        XCTAssertEqual(sut.errorMessage, DomainError.unauthorized.userMessage)
        XCTAssertEqual(sut.errorIcon, DomainError.unauthorized.icon)
        XCTAssertFalse(sut.isRetryable)
    }

    func testRetrieveImages_Failure_ServiceUnavailable() async {
        // GIVEN
        mockUseCase.shouldFail = true
        mockUseCase.customError = .serviceUnavailable

        // WHEN
        await sut.retrieveImages()

        // THEN
        XCTAssertTrue(sut.images.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.currentError, .serviceUnavailable)
        XCTAssertEqual(sut.errorMessage, DomainError.serviceUnavailable.userMessage)
        XCTAssertEqual(sut.errorIcon, DomainError.serviceUnavailable.icon)
        XCTAssertTrue(sut.isRetryable)
    }

    func testLoadMoreImages_AppendsResults() async {
        // GIVEN
        let initialImages = (1...2).map { makeImageModel(id: "\($0)") }
        let moreImages = (3...4).map { makeImageModel(id: "\($0)") }
        mockUseCase.stubbedResponse = initialImages
        await sut.retrieveImages()
        mockUseCase.stubbedResponse = moreImages
        mockUseCase.shouldFail = false

        // WHEN
        await sut.loadMoreImagesIfNeeded()

        // THEN
        XCTAssertFalse(sut.isLoadingMore)
    }

    func testLoadMoreImages_Failure_SetsCanLoadMorePagesFalse() async {
        // GIVEN
        let initialImages = (1...2).map { makeImageModel(id: "\($0)") }
        mockUseCase.stubbedResponse = initialImages
        await sut.retrieveImages()
        mockUseCase.shouldFail = true
        mockUseCase.customError = .serviceUnavailable

        // WHEN
        await sut.loadMoreImagesIfNeeded()

        // THEN
        XCTAssertFalse(sut.isLoadingMore)
    }

    func testShouldLoadMore_TrueNearEnd() {
        // GIVEN
        let images = (1...10).map { makeImageModel(id: "\($0)") }
        sut.images = images
        let currentImage = images[8] // index 8, threshold = 7

        // WHEN
        let shouldLoad = sut.shouldLoadMore(currentImage: currentImage)

        // THEN
        XCTAssertTrue(shouldLoad)
    }

    func testShouldLoadMore_FalseNotNearEnd() {
        // GIVEN
        let images = (1...10).map { makeImageModel(id: "\($0)") }
        sut.images = images
        let currentImage = images[2]

        // WHEN
        let shouldLoad = sut.shouldLoadMore(currentImage: currentImage)

        // THEN
        XCTAssertFalse(shouldLoad)
    }

    func testClearError_ResetsErrorState() {
        // GIVEN
        sut.errorMessage = "Some error"
        sut.showError = true
        sut.currentError = .unauthorized

        // WHEN
        sut.clearError()

        // THEN
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.currentError)
    }
}
