//
//  SkeletonImageView.swift
//  ImageApp
//
//  Skeleton placeholder that mimics ImageView structure
//  Used during initial loading with a shimmer animation
//

import SwiftUI

// MARK: - Shimmer Modifier

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.45), location: 0.45),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: phase * geometry.size.width * 2)
                    .animation(
                        .linear(duration: 1.2).repeatForever(autoreverses: false),
                        value: phase
                    )
                }
                .clipped()
            )
            .onAppear { phase = 1 }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Skeleton Identifiable wrapper

/// Lightweight wrapper to give skeleton placeholders an Identifiable id
struct SkeletonItem: Identifiable {
    let id: Int
    /// Randomized aspect ratio to simulate real image variety in MasonryView
    let aspectRatio: CGFloat

    static func placeholders(count: Int = 10) -> [SkeletonItem] {
        let ratios: [CGFloat] = [0.75, 1.0, 1.3, 0.85, 1.2, 0.65, 1.0, 0.9, 1.15, 0.7]
        return (0..<count).map { index in
            SkeletonItem(id: index, aspectRatio: ratios[index % ratios.count])
        }
    }
}

// MARK: - SkeletonImageView

struct SkeletonImageView: View {
    let aspectRatio: CGFloat

    init(aspectRatio: CGFloat = 1.0) {
        self.aspectRatio = aspectRatio
    }

    var body: some View {
        VStack(spacing: 0) {
            // Image placeholder
            Color.gray.opacity(0.25)
                .aspectRatio(aspectRatio, contentMode: .fit)
                .cornerRadius(16)
                .shimmer()

            // User info placeholder
            HStack(spacing: 8) {
                // Avatar
                Circle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 24, height: 24)
                    .shimmer()

                // Name bar
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.25))
                    .frame(height: 10)
                    .shimmer()

                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
        }
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(16)
    }
}
