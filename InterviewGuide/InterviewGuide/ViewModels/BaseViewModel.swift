//
//  BaseViewModel.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/22/24.
//

import Foundation

class BaseViewModel<T: Decodable> {
    
    // Define the base URL and port in one place
    let baseURL = "http://localhost"
    let port = "8080"
    
    // A helper function to construct the full URL
    func constructURL(for endpoint: String) -> String {
        return "\(baseURL):\(port)\(endpoint)"
    }
    
    // Fetch and decode data from the provided URL
    func fetchData(from endPoint: String) async throws -> [T] {
        guard let url = URL(string: constructURL(for: endPoint)) else {
            throw APIError.invalidURL
        }
        
        do {
            let (serverData, serverResponse) = try await URLSession.shared.data(from: url)
            
            guard let httpStatusCode = (serverResponse as? HTTPURLResponse)?.statusCode, (200...299).contains(httpStatusCode) else {
                throw APIError.nonSucessStatusCode
            }
            
            let decoder = JSONDecoder()
            
            // Custom DateFormatter to handle fractional seconds with time zone
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Handle the provided date format
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            // Decode the response data into the generic type
            return try decoder.decode([T].self, from: serverData)
        } catch {
            throw error
        }
    }
}
