//
//  ImageListView.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import SwiftUI

struct ImageListView: View {
    @StateObject private var viewModel = ImageListViewModel()
    
    let columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 2)

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    // Loading skeleton for initial load
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach((1...10), id: \.self) { number in
                            VStack(alignment: .leading) {
                                //Text("\(number)")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 250)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(16)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .padding()
                } else if viewModel.images.isEmpty && !viewModel.isLoading {
                    // Empty state (could be after error or no data)
                    emptyStateView
                } else {
                    VStack(spacing: 0) {
                        // Pinterest-style masonry layout with infinite scroll
                        MasonryLayout(columns: 2, spacing: 12) {
                            ForEach(viewModel.images, id: \.id) { image in
                                ImageView(image: image)
                                    .onAppear {
                                        // Trigger pagination when reaching near the end
                                        if viewModel.shouldLoadMore(currentImage: image) {
                                            Task {
                                                await viewModel.loadMoreImagesIfNeeded()
                                            }
                                        }
                                    }
                            }
                        }
                        .padding()
                        
                        // Loading indicator for pagination
                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Images")
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
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Ocurrió un error inesperado"),
                primaryButton: .default(Text("Reintentar")) {
                    viewModel.retryLastOperation()
                },
                secondaryButton: .cancel(Text("Cancelar")) {
                    viewModel.clearError()
                }
            )
        } else {
            return Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Ocurrió un error inesperado"),
                dismissButton: .default(Text("OK")) {
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
            
            Text(viewModel.errorMessage ?? "No hay imágenes para mostrar")
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
                        Text("Reintentar")
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
