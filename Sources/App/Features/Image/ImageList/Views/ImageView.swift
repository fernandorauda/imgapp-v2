//
//  ImageView.swift
//  ImageApp
//
//  Created by Adonys Rauda on 11/11/22.
//

import SwiftUI
import Kingfisher

typealias VoidAction = () -> Void

struct ImageView: View {
    let image: Image
    
    init(image: Image) {
        self.image = image
    }

    var body: some View {
        VStack(alignment: .leading) {
            KFImage.url(URL(string: image.urls.regular))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
        }
        .cornerRadius(24)
        .listRowSeparator(.hidden)
        
    }
}

