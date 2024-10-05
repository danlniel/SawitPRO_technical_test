//
//  ProductItem.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//


import SwiftUI

struct ProductItem: View {
    var title: String
    var price: String
    
    var body: some View {
        ZStack {
            Color.clear // Making the area tappable
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                Text(price.toRupiah())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
                .padding(.all, 12)
        }
    }
}

#Preview {
    ProductItem(title: "asd", price: "123")
}
