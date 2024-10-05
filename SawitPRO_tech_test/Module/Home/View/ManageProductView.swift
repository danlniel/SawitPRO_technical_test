//
//  ManageProductView.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

enum ManageProductState {
    case add(ProductData)
    case update(ProductData)
}

struct ManageProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItem: ProductData?
    @State private var name: String = ""
    @State private var price: String = ""
    
    let onCompletion: ((ManageProductState) -> Void)

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Name input
                TextField("Product Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                // Price input
                TextField("Product Price", text: $price)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                // Add/Update button
                Button(action: {
                    guard !name.isEmpty && !price.isEmpty else { return }
                    if let _selectedItem = selectedItem {
                        // Update new item
                        _selectedItem.name = name
                        _selectedItem.price = price.toInt()
                        onCompletion(.update(_selectedItem))
                    } else {
                        // Add new item
                        onCompletion(.add(.init(name: name, price: price.toInt())))
                    }
                    // Dismiss the modal
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(selectedItem != nil ? "Update" : "Tambah")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .navigationBarTitle(selectedItem != nil ? "Edit" : "Tambah", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onDisappear {
            selectedItem = nil
        }
        .onLoad {
            bind()
        }
    }
    
    private func bind() {
        if let selectedItem = selectedItem {
            name = selectedItem.name
            price = selectedItem.price.toString()
        }
    }
}
#Preview {
    ManageProductView(selectedItem: .constant(nil), onCompletion: { _ in })
}
