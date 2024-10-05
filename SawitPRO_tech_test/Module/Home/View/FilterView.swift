//
//  FilterView.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

struct FilterView: View {
    @Binding var minPrice: String
    @Binding var maxPrice: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Min price
                TextField("Minimum Price", text: $minPrice)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                // Max price
                TextField("Maximum Price", text: $maxPrice)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                // Apply button
                Button(action: {
                    // Apply the filter (just dismiss the view for now)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
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
            .navigationBarTitle("Filter", displayMode: .inline)
        }
    }
}

#Preview {
    FilterView(minPrice: .constant("123"), maxPrice: .constant("345"))
}
