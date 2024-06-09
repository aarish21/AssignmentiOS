//
//  FetchData.swift
//  AssignmentSwipe
//
//  Created by Aarish on 09/06/24.
//

import Foundation

struct Item: Codable, Identifiable {
    let id = UUID()
    let image: String
    let price: Double
    let productName: String
    let productType: String
    let tax: Double

    enum CodingKeys: String, CodingKey {
        case image
        case price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}

struct NewProduct: Codable {
    var productType: String = "Product"
    var productName: String = ""
    var price: String = ""
    var tax: String = ""
    var imageData: Data? = nil

    enum CodingKeys: String, CodingKey {
        case productType = "product_type"
        case productName = "product_name"
        case price
        case tax
        case imageData = "image"
    }
}
