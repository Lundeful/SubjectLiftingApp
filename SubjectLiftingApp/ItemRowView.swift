//
//  ItemRowView.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item
    let imageRadius: CGFloat = 75
    
    var body: some View {
        HStack(alignment: .center) {
            if let image = item.wrappedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageRadius, height: imageRadius)
            } else {
                Image(systemName: "questionmark")
                    .frame(width: imageRadius, height: imageRadius)
            }

            VStack(alignment: .leading) {
                Text(item.wrappedName)
                    .font(.headline)
                    .bold()
                Text(item.wrappedItemDescription)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: .example)
    }
}
