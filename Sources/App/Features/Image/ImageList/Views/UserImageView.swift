//
//  UserImageView.swift
//  ImageApp
//
//  Created by Adonys Rauda on 17/2/26.
//

import SwiftUI
import Kingfisher

struct UserInfoView: View {
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    var body: some View {
        HStack(spacing: 4) {
            KFImage.url(URL(string: user.profileImage.small))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .cornerRadius(16)
            
            Text(user.name)
                .font(.footnote)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 4)
    }
}
