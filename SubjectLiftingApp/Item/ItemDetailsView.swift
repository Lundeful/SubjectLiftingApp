//
//  ItemDetailsView.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI

struct ItemDetailsView: View {
    let item: Item
    let circleRadius: CGFloat = 140
    let imageRadius: CGFloat = 180

    var body: some View {
        VStack {
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
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name ?? "Unnamed item")
                    .font(.title)
                    .bold()
                Text(item.itemDescription ?? item.timestamp!.formatted(date: .numeric, time: .omitted))
            }
            Spacer()
        }
        .padding()
        .presentationBackground(.orange.gradient)
        .foregroundColor(.black)
        .cornerRadius(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailsView(item: .example)
    }
}
