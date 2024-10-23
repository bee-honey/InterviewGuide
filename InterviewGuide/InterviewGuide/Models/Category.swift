//
//  Category.swift
//  DeveloperInterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

struct Category: Decodable {
    let id: Int
    let categoryName: String
    let categoryDescription: String
    let createdAt: Date
    let updatedAt: Date
}
