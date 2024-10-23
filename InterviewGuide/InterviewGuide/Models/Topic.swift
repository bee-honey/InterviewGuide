//
//  Topic.swift
//  DeveloperInterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

struct Topic: Decodable {
    let id: Int
    let topicName: String
    let topicDescription: String
    let createdAt: Date
    let updatedAt: Date
}
