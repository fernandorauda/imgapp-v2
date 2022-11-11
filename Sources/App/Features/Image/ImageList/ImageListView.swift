//
//  ImageListView.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import SwiftUI

struct ImageListView: View {
    @StateObject private var viewModel = ImageListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.images, id: \.id) { image in
                    Spacer().frame(height: 16)
                    Text(image.user.name)
                        .listRowSeparator(.hidden)
                        .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Images")
            
        }.task {
            await viewModel.retrieveImages()
        }.refreshable {
            await viewModel.retrieveImages()
        }
    }
}
