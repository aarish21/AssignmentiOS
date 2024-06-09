//
//  AddProductView.swift
//  AssignmentSwipe
//
//  Created by Aarish on 09/06/24.
//
import SwiftUI
struct AddProductView: View {
    @ObservedObject var product: ViewModel
    @StateObject private var viewModel = AddProductViewModel()
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Information")) {
                    Picker("Product Type", selection: $viewModel.newProduct.productType) {
                        ForEach(viewModel.productTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Product Name", text: $viewModel.newProduct.productName)
                    TextField("Price", text: $viewModel.newProduct.price)
                        .keyboardType(.decimalPad)
                    TextField("Tax", text: $viewModel.newProduct.tax)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Select Image") {
                        showingImagePicker = true
                       
                    }
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Alert"), message: Text(viewModel.feedbackMessage ?? "Error"), dismissButton: .default(Text("OK")))
            }

            .navigationTitle("Add Product")
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(image: $viewModel.selectedImage)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        viewModel.submitProduct{
                            self.presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                product.fetchData()
                            }
                            
                        }
                       
                        
                    }
                }
            }
            
        }
    }
}
