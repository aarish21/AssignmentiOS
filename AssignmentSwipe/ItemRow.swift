//
//  ItemRow.swift
//  AssignmentSwipe
//
//  Created by Aarish on 10/06/24.
//
import SwiftUI
// custom list item
struct ItemRow: View {
    let item: Item
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            } placeholder: {
//                placeholder image
                Image("27002")
                    
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(item.productName)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Type: \(item.productType)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(format: "Price: %.1f", item.price))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(format: "Tax: %.1f", item.tax))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
