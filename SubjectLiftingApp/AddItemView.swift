//
//  AddItemView.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var showingImagePicker = false
    @State private var image: UIImage?

    @State private var showEmptyFieldsMessage = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Picture") {
                    VStack {
                        if let image {
                            VStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(maxHeight: 400)
                        } else {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Selecting an image")
                                    .font(.headline)
                                    .bold()
                                Text("The subject needs to be on a transparent background. There are two ways to accomplish this:")
                                    .font(.subheadline)
                                Text("1. Select image and choose an image where the subject is on a transparent background")
                                    .font(.subheadline)
                                Text("2. Go into the photos app, tap and hold on the subject to highlight it, press copy, and then come back here and press the paste button")
                                    .font(.subheadline)
                            }
                        }
                        HStack {
                            PhotosPicker(selection: $selectedImages, maxSelectionCount: 1, matching: .images) {
                                Text("Select Image")
                            }
                            .buttonStyle(.borderedProminent)
                            PasteButton(supportedContentTypes: [UTType.image]) { info in
                                for item in info {
                                    item.loadObject(ofClass: UIImage.self) { item, error in
                                        if let img = item as? UIImage {
                                            image = img
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }

                }

                Section("Item information") {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Add item")
            .toolbar {
                ToolbarItem {
                    Button("Save", action: addItem)
                }
            }
            .alert("Please fill in picture, name and description", isPresented: $showEmptyFieldsMessage) {
                Button("Ok", role: .cancel) {}
            }
            .onChange(of: selectedImages) { newValue in
                guard let item = newValue.first else { return }
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data {
                            image = UIImage(data: data)
                        } else {
                            print("No data from image")
                        }
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }

    private func addItem() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)

        guard image != nil, !trimmedName.isEmpty, !trimmedDescription.isEmpty else {
            showEmptyFieldsMessage = true
            return
        }

        let newItem = Item(context: viewContext)
        newItem.id = UUID()
        newItem.timestamp = Date()
        newItem.name = trimmedName
        newItem.itemDescription = trimmedDescription
        newItem.picture = image?.pngData()

        do {
            try viewContext.save()
            dismiss()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Reload preview to open sheet again")
            .sheet(isPresented: .constant(true)) {
                AddItemView()
            }
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
