import SwiftUI
import UIKit

class AddVM: ObservableObject {
   
    @Published var newProduct = NewProduct()
    @Published var productTypes = [
        "Blanket",
        "Product",
        "Pillow",
        "Electronics",
        "Service",
        "Water Bottle",
        "Vehicles",
        "Gaming Console",
        "Monitor",
        "Printer",
        "Mouse"
    ]
    @Published var selectedImage: UIImage? = nil
    @Published var feedbackMessage: String? = nil
    @Published var showAlert = false
//    submit the product using POST http request
    func submitProduct(onSuccess: @escaping () -> Void) {
        guard validateFields() else { return }
        
        let url = URL(string: "https://app.getswipe.in/api/public/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let formData = createFormData(boundary: boundary)
        request.httpBody = formData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    self.feedbackMessage = "Error: \(error.localizedDescription)"
                    self.showAlert  = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.feedbackMessage = "Product added successfully!"
                        self.showAlert  = false
                       
                        onSuccess()
                        
                    } else {
                        self.feedbackMessage = "Server error: \(httpResponse.statusCode)"
                        if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                            print("Response body: \(responseBody)")
                        }
                        self.showAlert  = true
                    }
                }
            }
        }.resume()
    }
    
    private func validateFields() -> Bool {
        if newProduct.productType.isEmpty || newProduct.productName.isEmpty || newProduct.price.isEmpty || newProduct.tax.isEmpty {
            feedbackMessage = "All fields are required."
            self.showAlert  = true
            return false
        }
        if Double(newProduct.price) == nil || Double(newProduct.tax) == nil {
            feedbackMessage = "Price and tax must be numbers."
            self.showAlert  = true
            return false
        }
        return true
    }
//    create the form data
    private func createFormData(boundary: String) -> Data {
        var data = Data()
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"product_name\"\r\n\r\n")
        data.append("\(newProduct.productName)\r\n")
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"product_type\"\r\n\r\n")
        data.append("\(newProduct.productType)\r\n")
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"price\"\r\n\r\n")
        data.append("\(newProduct.price)\r\n")
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"tax\"\r\n\r\n")
        data.append("\(newProduct.tax)\r\n")
        
        if let selectedImage = selectedImage {
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                data.append("--\(boundary)\r\n")
                data.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n")
                data.append("Content-Type: image/jpeg\r\n\r\n")
                data.append(imageData)
                data.append("\r\n")
            }
        }
        
        data.append("--\(boundary)--\r\n")
        
        return data
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
