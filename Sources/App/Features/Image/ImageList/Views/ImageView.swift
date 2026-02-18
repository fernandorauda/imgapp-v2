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
    let image: ImageModel
    
    init(image: ImageModel) {
        self.image = image
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                KFImage.url(URL(string: image.urls.regular))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                
                // Mostrar likes si existen
                if image.hasLikes {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                        Text(image.formattedLikesShort)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Color.black.opacity(0.6)
                            .cornerRadius(12)
                    )
                    .padding(8)
                }
            }
            .listRowSeparator(.hidden)
            
            UserInfoView(user: image.user)
        }
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(16)
    }
}
