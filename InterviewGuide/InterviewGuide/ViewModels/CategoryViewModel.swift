//
//  CategoryViewModel.swift
//  DeveloperInterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

class CategoryViewModel {
    var categories: [Category] = []
    
    
    func fetchCategories() async throws {
        guard let url = URL(string: "http://localhost:8080/api/v1/categories") else {
            return
        }
        
        do {
            let (serverData, serverResponse) = try await URLSession.shared.data(from: url)
            
            guard let httpStatusCode = (serverResponse as? HTTPURLResponse)?.statusCode, (200...299).contains(httpStatusCode) else {
                //Need to make sure that this error shows up as an alert/app banner
                throw APIError.nonSucessStatusCode
            }
            
            let decoder = JSONDecoder()
            
            // Custom DateFormatter to handle fractional seconds with time zone
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Handle the provided date format
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            // Decode the response data
            self.categories = try decoder.decode([Category].self, from: serverData)
            print(categories)
        } catch {
            throw error
        }
    }
}
