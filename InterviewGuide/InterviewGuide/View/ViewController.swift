//
//  ViewController.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import UIKit

class ViewController: UITableViewController {
    
    let categoryViewModel = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        // Create and assign the refresh control directly to the tableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCategories), for: .valueChanged)
        tableView.refreshControl = refreshControl // Use the tableView's built-in refreshControl
        
        Task {
            await loadInitialData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryViewModel.categories[indexPath.row]
        cell.textLabel?.text = category.categoryName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryViewModel.categories[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TopicsViewController") as? TopicsViewController {
            vc.categoryID = category.id
            vc.categoryTitle = category.categoryName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func refreshCategories() {
        Task {
            do {
                try await categoryViewModel.fetchCategories() // Fetch data
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
            try await categoryViewModel.fetchCategories() // Fetch data
            tableView.reloadData() // Refresh table view
        } catch {
            print("Error loading initial data: \(error)")
        }
    }
}

