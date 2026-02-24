//
//  ImageListViewTest.swift
//  ImageApp
//
//  Created by GitHub Copilot on 23/2/26.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import ImageApp

@MainActor
final class ImageListViewTest: XCTestCase {
    private var mockUseCase: MockRetrieveImagesUseCase!
    private var viewModel: ImageListViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        mockUseCase = .init()
        viewModel = .init(retrieveImagesUseCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
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

    private func makeView() -> ImageListView {
        ImageListView(viewModel: viewModel)
    }

    // MARK: - Navigation

    func testView_ContainsNavigationView() throws {
        let view = makeView()
        XCTAssertNoThrow(try view.inspect().find(ViewType.NavigationView.self))
    }

    // MARK: - Loading state

    func testLoadingState_ShowsLazyVGrid() throws {
        viewModel.isLoading = true

        let view = makeView()
        // Cuando isLoading=true la vista muestra un LazyVGrid de skeleton
        XCTAssertNoThrow(try view.inspect().find(ViewType.LazyVGrid.self))
    }

    func testLoadingState_DoesNotShowRetryButton() throws {
        viewModel.isLoading = true

        let view = makeView()
        XCTAssertThrowsError(try view.inspect().find(button: "Reintentar"))
    }

    // MARK: - Empty state

    func testEmptyState_ShowsFallbackMessage_WhenNoErrorMessage() throws {
        viewModel.isLoading = false
        viewModel.images = []
        viewModel.errorMessage = nil

        let view = makeView()
        let text = try view.inspect().find(text: "No hay imágenes para mostrar")
        XCTAssertNotNil(text)
    }

    func testEmptyState_ShowsCustomErrorMessage() throws {
        let message = "No hay imágenes"
        viewModel.isLoading = false
        viewModel.images = []
        viewModel.errorMessage = message

        let view = makeView()
        let text = try view.inspect().find(text: message)
        XCTAssertNotNil(text)
    }

    func testEmptyState_ShowsRetryButton_WhenIsRetryableTrue() throws {
        viewModel.isLoading = false
        viewModel.images = []
        viewModel.isRetryable = true

        let view = makeView()
        let text = try view.inspect().find(text: "Reintentar")
        XCTAssertNotNil(text)
    }

    func testEmptyState_HidesRetryButton_WhenIsRetryableFalse() throws {
        viewModel.isLoading = false
        viewModel.images = []
        viewModel.isRetryable = false

        let view = makeView()
        XCTAssertThrowsError(try view.inspect().find(text: "Reintentar"))
    }

    func testEmptyState_ShowsErrorIcon() throws {
        viewModel.isLoading = false
        viewModel.images = []
        viewModel.errorIcon = "exclamationmark.triangle"

        XCTAssertEqual(viewModel.errorIcon, "exclamationmark.triangle")
        XCTAssertTrue(viewModel.images.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    // MARK: - Images list

    func testImagesList_ShowsScrollView_WhenImagesAvailable() throws {
        viewModel.isLoading = false

        let view = makeView()
        XCTAssertNoThrow(try view.inspect().find(ViewType.ScrollView.self))
    }

    func testImagesList_ShowsVStack_AsContainerForMasonry() throws {
        viewModel.isLoading = false

        let view = makeView()
        XCTAssertNoThrow(try view.inspect().find(ViewType.VStack.self))
    }

    func testImagesList_DoesNotShowSkeletonGrid_WhenImagesAvailable() throws {
        viewModel.isLoading = false

        let view = makeView()
        XCTAssertThrowsError(try view.inspect().find(ViewType.LazyVGrid.self))
    }

    // MARK: - Load more indicator

    func testLoadMoreIndicator_IsVisible_WhenIsLoadingMoreTrue() throws {
        viewModel.isLoading = false
        viewModel.isLoadingMore = true

        XCTAssertTrue(viewModel.isLoadingMore)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadMoreIndicator_IsHidden_WhenIsLoadingMoreFalse() throws {
        viewModel.isLoading = false
        viewModel.isLoadingMore = false

        let view = makeView()
        XCTAssertThrowsError(
            try view.inspect().find(viewWithAccessibilityIdentifier: "loadingMoreIndicator")
        )
    }

    // MARK: - Error alert state

    func testShowError_True_SetsAlertBinding() throws {
        viewModel.showError = true
        viewModel.errorMessage = "Credenciales inválidas."
        viewModel.isRetryable = false

        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Credenciales inválidas.")
        XCTAssertFalse(viewModel.isRetryable)
    }

    func testShowError_False_NoAlert() throws {
        viewModel.showError = false

        XCTAssertFalse(viewModel.showError)
    }
}
