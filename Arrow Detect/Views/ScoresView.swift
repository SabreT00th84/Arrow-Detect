//
//  ContentView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/10/2024.
//

import SwiftUI
import SwiftData

struct ScoresView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = ScoresViewModel()
    @Query private var items: [Item]
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationDestination(isPresented: $viewModel.showScoresheet, destination: {ScoresheetView()})
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                        
                    }
                }
            }
        } detail: {Text("Select Item")}
            
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
            viewModel.showScoresheet = true
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ScoresView()
        .modelContainer(for: Item.self, inMemory: true)
}
