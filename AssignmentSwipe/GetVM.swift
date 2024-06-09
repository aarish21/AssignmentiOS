//
//  ViewModel.swift
//  AssignmentSwipe
//
//  Created by Aarish on 09/06/24.
//

import Foundation

class GetVM: ObservableObject {
    @Published var items: [Item] = []

    init() {
        fetchData()
    }
//    fetch data using urlsession 
    func fetchData() {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    self.items = items
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }
}
