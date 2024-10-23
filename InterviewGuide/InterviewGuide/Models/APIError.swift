//
//  APIError.swift
//  DeveloperInterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

enum APIError: Error {
    case nonSucessStatusCode
    case networkingIssue
    case invalidData
    case invalidRequest
}
