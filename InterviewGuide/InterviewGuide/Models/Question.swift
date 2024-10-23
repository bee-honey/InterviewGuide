//
//  Question.swift
//  DeveloperInterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

// Answer model
struct Answer: Decodable {
    let id: Int
    let answerText: String
    let createdAt: Date
    let updatedAt: Date
    let isCorrect: Bool
}

// Question model
struct Question: Decodable {
    let id: Int
    let questionText: String
    let questionType: String
    let answers: [Answer]
    let createdAt: Date
    let updatedAt: Date
}
