//
//  MasonryLayout.swift
//  ImageApp
//
//  Masonry/Pinterest-style layout for images
//

import SwiftUI

struct LazyMasonryView<Content: View, Item: Identifiable>: View {
    let items: [Item]
    let columns: Int
    let spacing: CGFloat
    let content: (Item) -> Content
    
    init(items: [Item], columns: Int = 2, spacing: CGFloat = 16, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    private var columnsData: [[Item]] {
        var result: [[Item]] = Array(repeating: [], count: columns)
        for (index, item) in items.enumerated() {
            result[index % columns].append(item)
        }
        return result
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: spacing) {
                    ForEach(columnsData[columnIndex]) { item in
                        content(item)
                    }
                }
            }
        }
    }
}
