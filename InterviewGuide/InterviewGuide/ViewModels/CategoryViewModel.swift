//
//  CategoryViewModel.swift
//  DeveloperInterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import Foundation

class CategoryViewModel : BaseViewModel<Category> {
    var categories: [Category] = []
    
    func fetchCategories() async throws {
        let endPoint = "/api/v1/categories"
        self.categories = try await fetchData(from: endPoint)
        debugPrint(self.categories)
    }
}
