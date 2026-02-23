//
//  ImageDataSourceTest.swift
//  ImageApp
//
//  Created by Adonys Rauda on 22/2/26.
//

import XCTest

@testable import ImageApp

@MainActor
final class ImageDataSourceTest: XCTestCase {
    private var sut: ImageDataSource!
    private var mockApiService: MockApiProvider!
    
    override func setUp() {
        super.setUp()
        mockApiService = MockApiProvider()
        sut = ImageDataSource(apiProvider: mockApiService)
    }
    
    
    override func tearDown() {
        sut = nil
        mockApiService = nil
        super.tearDown()
    }
    
    func testRetrieveImages_Success() async throws {
        // GIVEN
        let mockImagesRequest = ImagesRequest(page: 1, perPage: 10)
        let mockImageDto = ImageDto(id: "1", likes: 2, desc: nil, urls: nil, user: nil, createdAt: nil)
        let mockImagesResponse = [mockImageDto]
        
        mockApiService.stubbedResponse = mockImagesResponse
        mockApiService.shouldFail = false

        // WHEN
        let result = try await sut.retrieveImages(imagesRequest: mockImagesRequest)
        
        
        // THEN
        XCTAssertEqual(mockApiService.requestCallCount, 1)
        XCTAssertEqual(result.count, mockImagesResponse.count)
        XCTAssertEqual(result.first?.id, mockImageDto.id)
    }
    
    func testRetrieveImages_Failure() async throws {
        // GIVEN
        let mockImagesRequest = ImagesRequest(page: 1, perPage: 10)
        mockApiService.shouldFail = true
        
        // WHEN
        
        do {
            let result = try await sut.retrieveImages(imagesRequest: mockImagesRequest)
            
            XCTFail("Expected to throw an error, but got \(result)")
        } catch let error as NetworkError {
            // THEN
            XCTAssertEqual(mockApiService.requestCallCount, 1)
            XCTAssertEqual(error.statusCode, 404)
        }
    }
}
