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
    let imageRadius: CGFloat = 75

    var body: some View {
        HStack {
            Spacer()
            if let image = item.wrappedImage {
                ZStack {
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: circleRadius, height: circleRadius)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageRadius, height: imageRadius)
                }
            } else {
                Spacer()
                    .frame(width: imageRadius, height: imageRadius)
            }
            VStack(alignment: .leading) {
                Text(item.name ?? "Unnamed item")
                    .font(.headline)
                Text(item.itemDescription ?? item.timestamp!.formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding()
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
