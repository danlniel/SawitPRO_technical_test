//
//  HomeView.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Combine
import SwiftUI
import SwiftData

struct HomeView: View {
    @Query var productDataSource: [ProductData]
    
    @StateObject private var viewModel: HomeViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DependencyContainer.shared.resolve(HomeViewModel.self)!)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                HStack {
                    Text(String.localized(LocalizableKeys.home))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    connectivityView()
                }
                
                // Search bar with filter button
                HStack {
                    TextField(String.localized(LocalizableKeys.search), text: $viewModel.searchText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.leading)
                    
                    Button(action: {
                        viewModel.isFilterModalPresented = true
                    }) {
                        Image(systemName: RegisteredImage.miniCircle)
                            .font(.title2)
                            .padding()
                    }
                    .sheet(isPresented: $viewModel.isFilterModalPresented) {
                        // Show the filter modal
                        FilterView(minPrice: $viewModel.minPrice, maxPrice: $viewModel.maxPrice)
                    }
                    .padding(.trailing)
                }
                
                // List view
                List {
                    ForEach(viewModel.filteredProductList) { product in
                        ProductItem(title: product.name, price: product.price.toString())
                            .onTapGesture {
                                viewModel.selectedProduct = product
                                viewModel.isAddItemModalPresented = true
                            }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(PlainListStyle())
                .toolbar {
                    EditButton()
                }
            }
            .padding(.bottom, 16)
            
            // Floating button to add item
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.isAddItemModalPresented = true
                    }) {
                        Image(systemName: RegisteredImage.plus)
                            .font(.system(size: 24))
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding()
                    .sheet(isPresented: $viewModel.isAddItemModalPresented) {
                        // Show add item modal
                        ManageProductView(
                            selectedItem: $viewModel.selectedProduct,
                            onCompletion: { state in
                                handleManageProductView(state: state)
                            }
                        )
                    }
                }
            }
            
            // Snackbar
            createSnackbar(result: viewModel.result)
        }
        .onLoad {
            viewModel.start()
            viewModel.update(productDataSource)
        }
        .onChange(of: productDataSource) { _, newValue in
            viewModel.update(newValue)
        }
    }
    
    private func handleManageProductView(state: ManageProductState) {
        if case .add(let data) = state {
            viewModel.addProduct(data: data)
        } else if case .update(_) = state {
            viewModel.saveProduct()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let data = viewModel.filteredProductList[index]
            viewModel.removeProduct(data: data)
        }
    }
    
    @ViewBuilder
    private func createSnackbar(result: SaveResult) -> some View {
        switch result {
        case .success(let message):
            Snackbar(
                message: message,
                type: .success,
                isShowing: $viewModel.isSnackbarShowing
            )
        case .failure(let message):
            Snackbar(
                message: message,
                type: .error,
                isShowing: $viewModel.isSnackbarShowing
            )
        case .none: EmptyView()
        }
    }
    
    
    @ViewBuilder
    private func connectivityView() -> some View {
        switch viewModel.homeState {
        case .online:
            Text(String.localized(LocalizableKeys.online))
                .foregroundColor(.green)
        case .offline:
            Text(String.localized(LocalizableKeys.offline))
                .foregroundColor(.red)
        case .syncing:
            Text(String.localized(LocalizableKeys.syncing))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    HomeView()
}
