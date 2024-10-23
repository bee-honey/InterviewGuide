//
//  TopicViewModel.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

class TopicViewModel: BaseViewModel<Topic> {
    var topics: [Topic] = []
    
    
    func fetchTopics(categoryID: Int) async throws {
        let endPoint = "/api/v1/categories/\(categoryID)/topics"
        self.topics = try await fetchData(from: endPoint)
        debugPrint(self.topics)
    }
}
