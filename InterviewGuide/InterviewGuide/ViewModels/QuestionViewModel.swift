//
//  QuestionViewModel.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

class QuestionViewModel {
    
    var questions: [Question] = []
    
    func fetchQuestions(categoryID: Int, topicID: Int) async throws {
        guard let url = URL(string: "http://localhost:8080/api/v1/categories/\(categoryID)/topics/\(topicID)/questions") else {
            return
        }
        
        do {
            let (serverData, serverResponse) = try await URLSession.shared.data(from: url)
            
            guard let httpStatusCode = (serverResponse as? HTTPURLResponse)?.statusCode, (200...299).contains(httpStatusCode) else {
                throw APIError.nonSucessStatusCode
            }
            
            let decoder = JSONDecoder()
            
            // Custom DateFormatter to handle the date format in the JSON
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            // Decode the response data into an array of questions
            self.questions = try decoder.decode([Question].self, from: serverData)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
}
