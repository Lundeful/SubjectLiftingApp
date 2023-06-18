//
//  ItemDetailsView.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI

struct ItemDetailsView: View {
    let item: Item
    let imageRadius: CGFloat = 180

    var body: some View {
        VStack {
            if let image = item.wrappedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageRadius, height: imageRadius)

            } else {
                Spacer()
                    .frame(width: imageRadius, height: imageRadius)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(item.wrappedName)
                    .font(.largeTitle)
                    .bold()
                Text(item.wrappedItemDescription)
            }
            Spacer()
        }
        .presentationBackground(.orange.gradient)
        .foregroundColor(.black)
        .padding()
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct ItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Reload preview to display sheet")
            .sheet(isPresented: .constant(true)) {
                ItemDetailsView(item: .example)
            }
    }
}
