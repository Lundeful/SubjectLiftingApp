//
//  ContentView.swift
//  SubjectLiftingApp
//
//  Created by Christoffer Lund on 16/06/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showingAddItemSheet = false
    @State private var selectedItem: Item?

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.displayOrder, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    ItemRowView(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedItem = item
                        }
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showingAddItemSheet = true
                    } label: {
                        Label("Add item", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $selectedItem) { item in
                ItemDetailsView(item: item)
            }
            .sheet(isPresented: $showingAddItemSheet) {
                AddItemView()
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }

    private func moveItems(from source: IndexSet, to destination: Int) {
        var revisedItems: [Item] = items.map { $0 }
        revisedItems.move(fromOffsets: source, toOffset: destination)

        for index in 0..<revisedItems.count {
            revisedItems[index].displayOrder = Int16(index)
        }

        try? viewContext.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
