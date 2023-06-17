//
//  Item-CoreDataHelpers.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI

extension Item {
    var wrappedImage: UIImage? {
        if let imageData = picture, let image = UIImage(data: imageData) {
            return image
        }

        return nil
    }

    static var example: Item {
        let controller = PersistenceController.preview
        let viewContext  = controller.container.viewContext

        let item = Item(context: viewContext)
        item.id = UUID()
        item.timestamp = Date()
        item.name = ExampleData.names.randomElement()!
        item.itemDescription = ExampleData.descriptions.randomElement()!
        item.picture = ExampleData.pictures.randomElement()!.pngData()

        try? viewContext.save()

        return item
    }
}
