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
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.images, id: \.id) { image in
                        ImageView(image: image)
                            .listRowSeparator(.hidden)
                            .buttonStyle(.plain)
                    }
                }
                .padding()
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
