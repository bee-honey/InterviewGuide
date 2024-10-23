//
//  TopicViewModel.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

class TopicViewModel {
    var topics: [Topic] = []
    
    
    func fetchTopics(categoryID: Int) async throws {
        guard let url = URL(string: "http://localhost:8080/api/v1/categories/\(categoryID)/topics") else {
            return
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
            
            // Decode the response data
            self.topics = try decoder.decode([Topic].self, from: serverData)
            print(topics)
        } catch {
            throw error
        }
    }
}
