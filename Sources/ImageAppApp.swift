//
//  ImageAppApp.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import SwiftUI

@main
struct ImageAppApp: App {
    @StateObject private var container  = DIContainer();
    
    var body: some Scene {
        WindowGroup {
            ImageListView(viewModel: container.makeImageListViewModel()).environmentObject(container)
        }
    }
}
