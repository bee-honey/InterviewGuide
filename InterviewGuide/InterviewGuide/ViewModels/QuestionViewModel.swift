//
//  QuestionViewModel.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

class QuestionViewModel: BaseViewModel<Question> {
    
    var questions: [Question] = []
    
    func fetchQuestions(categoryID: Int, topicID: Int) async throws {
        let endPoint = "/api/v1/categories/\(categoryID)/topics/\(topicID)/questions"
        self.questions = try await fetchData(from: endPoint)
        debugPrint(self.questions)
    }
    
}
