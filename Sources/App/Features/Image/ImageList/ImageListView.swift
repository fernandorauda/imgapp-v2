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
            
        }.task {
            await viewModel.retrieveImages()
        }.refreshable {
            await viewModel.retrieveImages()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
