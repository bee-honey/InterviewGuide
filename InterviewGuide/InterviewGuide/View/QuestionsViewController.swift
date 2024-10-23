//
//  QuestionsViewController.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import UIKit

class QuestionsViewController: UITableViewController {
    
    var categoryID: Int?
    var topicID: Int?
    let questionViewModel = QuestionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCategories), for: .valueChanged)
        tableView.refreshControl = refreshControl // Use the tableView's built-in refreshControl
        
        Task {
            await loadInitialData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionViewModel.questions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let question = questionViewModel.questions[indexPath.row]
        print(question)
        cell.textLabel?.text = question.questionText
        return cell
    }
    
    @objc func refreshCategories() {
        Task {
            do {
                try await questionViewModel.fetchQuestions(categoryID: self.categoryID ?? 0, topicID: self.topicID ?? 0) // Fetch data
                self.tableView.reloadData() // Refresh table view
                self.tableView.refreshControl?.endRefreshing() // End refresh
            } catch {
                print("NKK: Error refreshing categories: \(error)")
                tableView.refreshControl?.endRefreshing() // End refresh in case of error
            }
        }
    }
    
    func loadInitialData() async {
        do {
            try await questionViewModel.fetchQuestions(categoryID: self.categoryID ?? 0, topicID: self.topicID ?? 0)
            tableView.reloadData() // Refresh table view
        } catch {
            print("Error loading initial data: \(error)")
        }
    }
    
    
}
