//
//  TopicsViewController.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import UIKit

class TopicsViewController: UITableViewController {
    
    var categoryID: Int?
    var categoryTitle: String?
    let topicViewModel = TopicViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = categoryTitle ?? "Topic"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCategories), for: .valueChanged)
        tableView.refreshControl = refreshControl // Use the tableView's built-in refreshControl
        
        Task {
            await loadInitialData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topicViewModel.topics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)
        let topic = topicViewModel.topics[indexPath.row]
        cell.textLabel?.text = topic.topicName
        return cell
    }
    
    @objc func refreshCategories() {
        Task {
            do {
                try await topicViewModel.fetchTopics(categoryID: self.categoryID ?? 0) // Fetch data
                self.tableView.reloadData() // Refresh table view
                self.tableView.refreshControl?.endRefreshing() // End refresh
            } catch {
                debugPrint("NKK: Error refreshing categories: \(error)")
                tableView.refreshControl?.endRefreshing() // End refresh in case of error
            }
        }
    }
    
    func loadInitialData() async {
        do {
            try await topicViewModel.fetchTopics(categoryID: self.categoryID ?? 0 ) // Fetch data
            tableView.reloadData() // Refresh table view
        } catch {
            debugPrint("Error loading initial data: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topicViewModel.topics[indexPath.row]
        
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController {
//            vc.categoryID = categoryID
//            vc.topicID = topic.id
//            navigationController?.pushViewController(vc, animated: true)
//        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionsVC") as? QuestionsVC {
            vc.categoryID = categoryID
            vc.topicID = topic.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
