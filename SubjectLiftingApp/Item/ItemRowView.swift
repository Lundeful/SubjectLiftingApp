//
//  ItemRowView.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item
    let circleRadius: CGFloat = 55
    let imageRadius: CGFloat = 125
    
    var body: some View {
        HStack {
            if let image = item.wrappedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageRadius, height: imageRadius)

            } else {
                Spacer()
                    .frame(width: imageRadius, height: imageRadius)
            }
            VStack(alignment: .leading) {
                Text(item.name ?? "Unnamed item")
                    .font(.title)
                    .bold()
                Text(item.itemDescription ?? item.timestamp!.formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(10)
        .background(.orange.gradient)
        .foregroundColor(.black)
        .cornerRadius(15)
        .frame(maxWidth: .infinity)
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: .example)
    }
}
