//
//  ContentView.swift
//  AssignmentSwipe
//
//  Created by Aarish on 09/06/24.
//


import SwiftUI

struct Dashboard: View {
    @State private var showAddOption = false
    @StateObject private var getVM = GetVM()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredItems) { item in
//                    using the ItemRow UI here
                    ItemRow(item: item)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Swipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddOption = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddOption) {
                AddView(getVM: getVM)
            }
            .onAppear {
                getVM.fetchData()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return getVM.items
        } else {
            return getVM.items.filter { $0.productName.localizedCaseInsensitiveContains(searchText) }
        }
    }
}



#Preview {
    Dashboard()
}
