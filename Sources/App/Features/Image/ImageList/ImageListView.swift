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
                    LazyVGrid(columns: columns, content: {
                        ForEach((1...10), id: \.self) { number in
                            VStack(alignment: .leading) {
                                //Text("\(number)")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(24)
                            .listRowSeparator(.hidden)
                        }
                    })
                    .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.images, id: \.id) { image in
                            ImageView(image: image)
                                .listRowSeparator(.hidden)
                                .buttonStyle(.plain)
                        }
                    }
                    .padding()
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
