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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(items) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            ItemRowView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteItems)
                }
                .padding()
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingAddItemSheet = true
                    } label: {
                        Label("Show sheet", systemImage: "plus")
                    }
                }
            }
            .sheet(item: $selectedItem) { item in

                ItemDetailsView(item: item)
                    .padding()
                    .presentationDetents([.large, .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingAddItemSheet) {
                if let selectedItem {
                    ItemDetailsView(item: selectedItem)
                } else {
                    Text("Here you can add an item")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
