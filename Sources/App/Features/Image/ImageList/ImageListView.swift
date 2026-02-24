//
//  ImageListView.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import SwiftUI

struct ImageListView: View {
    @ObservedObject private var viewModel: ImageListViewModel
    
    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    LazyMasonryView(
                        items: SkeletonItem.placeholders(count: 10),
                        columns: 2,
                        spacing: 12
                    ) { skeleton in
                        SkeletonImageView(aspectRatio: skeleton.aspectRatio)
                    }
                    .padding()
                    .allowsHitTesting(false)
                } else if viewModel.images.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    VStack(spacing: 0) {
                        LazyMasonryView(items: viewModel.images, columns: 2, spacing: 12) { image in
                            ImageView(image: image)
                                .onAppear {
                                    if viewModel.shouldLoadMore(currentImage: image) {
                                        Task {
                                            await viewModel.loadMoreImagesIfNeeded()
                                        }
                                    }
                                }
                        }
                        .padding()
                        
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                                Spacer()
                            }
                            .accessibilityIdentifier("loadingMoreIndicator")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(L10n.Navigation.imagesTitle)
            .alert(isPresented: $viewModel.showError) {
                createErrorAlert()
            }
        }
        .task {
            await viewModel.retrieveImages()
        }
        .refreshable {
            
            await viewModel.retrieveImages()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Error Alert
    
    private func createErrorAlert() -> Alert {
        if viewModel.isRetryable {
            return Alert(
                title: Text(L10n.Error.title),
                message: Text(viewModel.errorMessage.map { LocalizedStringKey($0) } ?? L10n.Error.unexpected),
                primaryButton: .default(Text(L10n.Action.retry)) {
                    viewModel.retryLastOperation()
                },
                secondaryButton: .cancel(Text(L10n.Action.cancel)) {
                    viewModel.clearError()
                }
            )
        } else {
            return Alert(
                title: Text(L10n.Error.title),
                message: Text(viewModel.errorMessage.map { LocalizedStringKey($0) } ?? L10n.Error.unexpected),
                dismissButton: .default(Text(L10n.Action.ok)) {
                    viewModel.clearError()
                }
            )
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: viewModel.errorIcon)
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(viewModel.errorMessage.map { LocalizedStringKey($0) } ?? L10n.ImageList.emptyMessage)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if viewModel.isRetryable {
                Button(action: {
                    Task {
                        await viewModel.retrieveImages()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text(L10n.Action.retry)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
