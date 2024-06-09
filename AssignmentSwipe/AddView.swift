//
//  AddProductView.swift
//  AssignmentSwipe
//
//  Created by Aarish on 09/06/24.
//
import SwiftUI
struct AddView: View {
    @ObservedObject var getVM: GetVM
    @StateObject private var addVM = AddVM()
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Information")) {
                    Picker("Product Type", selection: $addVM.newProduct.productType) {
                        ForEach(addVM.productTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Product Name", text: $addVM.newProduct.productName)
                    TextField("Price", text: $addVM.newProduct.price)
                        .keyboardType(.decimalPad)
                    TextField("Tax", text: $addVM.newProduct.tax)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Select Image") {
                        showingImagePicker = true
                       
                    }
                    if let selectedImage = addVM.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                }
            }
            .alert(isPresented: $addVM.showAlert) {
//                show alert on  failure
                Alert(title: Text("Alert"), message: Text(addVM.feedbackMessage ?? "Error"), dismissButton: .default(Text("OK")))
            }

            .navigationTitle("Add Product")
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(image: $addVM.selectedImage)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        addVM.submitProduct{
                            self.presentationMode.wrappedValue.dismiss()
//                            fetch and update the Dashboard
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                getVM.fetchData()
                            }
                            
                        }
                       
                        
                    }
                }
            }
            
        }
    }
}
