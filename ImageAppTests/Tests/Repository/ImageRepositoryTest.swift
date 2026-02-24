//
//  ImageRepositoryTest.swift
//  ImageApp
//
//  Created by Adonys Rauda on 23/2/26.
//

import XCTest

@testable import ImageApp

@MainActor
final class ImageRepositoryTest: XCTestCase {
    private var sut: ImageRepository!
    private var mockImageDataSource: MockImageDataSource!
    
    override func setUp() {
        super.setUp()
        mockImageDataSource = .init()
        sut = .init(dataSource: mockImageDataSource)
    }
    
    override func tearDown() {
        sut = nil
        mockImageDataSource = nil
        super.tearDown()
    }
    
    func testRetrieveImages_Success() async throws {
        // GIVEN
        let mockImagesRequest = ImagesRequest(page: 1, perPage: 10)
        let mockImageDto = ImageDto(id: "1", likes: 2, desc: nil, urls: nil, user: nil, createdAt: nil)
        let mockImages = [mockImageDto]
        
        mockImageDataSource.stubbedResponse = mockImages
        mockImageDataSource.shouldFail = false
        
        // WHEN
        let result = try await sut.retrieveImages(imagesRequest: mockImagesRequest)
        
        // THEN
        XCTAssertEqual(mockImageDataSource.retrieveImagesCalledCount, 1)
        XCTAssertEqual(result.first?.id, mockImageDto.id)
    }
    
    func testRetrieveImages_Failure() async throws {
        let mockImagesRequest = ImagesRequest(page: 1, perPage: 10)
        mockImageDataSource.shouldFail = true
        
        do {
            let result = try await sut.retrieveImages(imagesRequest: mockImagesRequest)
            
            XCTFail("Expected to throw, but got \(result)")
        } catch let error as DomainError {
            XCTAssertEqual(mockImageDataSource.retrieveImagesCalledCount, 1)
            guard case .unauthorized = error else {
                XCTFail("Expected DomainError.unauthorized but got: \(error)")
                return
            }
        } catch {
            XCTFail("Expected DomainError but got: \(error)")
        }
    }
}
