//
//  QuestionsVC.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/21/24.
//

import UIKit

class QuestionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI Elements
    var questionLabel: UILabel!
    var tableView: UITableView!
    var resultLabel: UILabel!
    var submitButton: UIButton!
    var previousButton: UIButton!
    var nextButton: UIButton!
    
    // Data
    var categoryID: Int?
    var topicID: Int?
    let questionViewModel = QuestionViewModel()
    var questions: [Question] = []
    var currentQuestionIndex: Int = 0
    var selectedAnswerIndex: Int? // Track the selected answer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the custom cell class with correct identifier
        tableView.register(AnswerCell.self, forCellReuseIdentifier: "AnswerCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Do any additional setup after loading the view.
        Task {
            await loadQuestions()
            
            // Show the first question
            if (questions.count > 0) {
                showQuestion(at: currentQuestionIndex)
            } else {
                debugPrint("No questions to show")
            }
            
        }
        
        setupUI()
        
        NSLayoutConstraint.activate([
            // Your table view layout constraints
            tableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func loadQuestions() async {
        do {
            try await questionViewModel.fetchQuestions(categoryID: self.categoryID ?? 0, topicID: self.topicID ?? 0)
            questions = questionViewModel.questions
        } catch {
            debugPrint("Error loading initial data: \(error)")
        }
    }
    
    // Show a specific question and its answers
    func showQuestion(at index: Int) {
        
        let question = questions[index]
        questionLabel.text = question.questionText
        
        selectedAnswerIndex = nil // Reset the selected answer
        tableView.reloadData()
        
        // Enable/Disable buttons based on current question
        previousButton.isEnabled = index > 0
        nextButton.isEnabled = index < questions.count - 1
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Question Label
        questionLabel = UILabel()
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 24)
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)
        
        // Result Label
        resultLabel = UILabel()
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.systemFont(ofSize: 18)
        resultLabel.numberOfLines = 0
        resultLabel.textColor = .black
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel) // Add the result label
        
        // Submit Button
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        // Previous Button
        previousButton = UIButton(type: .system)
        previousButton.setTitle("Previous", for: .normal)
        previousButton.addTarget(self, action: #selector(previousQuestion), for: .touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previousButton)
        
        // Next Button
        nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        // Layout
        NSLayoutConstraint.activate([
            // Question label constraints
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Result label constraints (position it below the submit button)
            resultLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Previous and Next buttons constraints
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            // Submit button
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.isEmpty || currentQuestionIndex >= questions.count {
            return 0
        } else {
            return questions[currentQuestionIndex].answers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        let answer = questions[currentQuestionIndex].answers[indexPath.row]
        
        // Configure the cell with answer text and radio button state
        let isSelected = (indexPath.row == selectedAnswerIndex) // Check if this cell is selected
        cell.configure(with: answer.answerText, isSelected: isSelected)
        
        return cell
    }
    
    // Optional: Dynamic row height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        tableView.reloadData() // Refresh the checkmark
    }
    
    
    // MARK: - Question Navigation buttons
    // Handle answer button tap
    @objc func answerTapped(sender: UIButton) {
        guard let answerText = sender.title(for: .normal) else { return }
        debugPrint("Selected answer: \(answerText)")
    }
    
    // Handle "Next" button tap
    @objc func nextQuestion() {
        resultLabel.text = ""
        resultLabel.textColor = .white
        submitButton.isEnabled = true
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            showQuestion(at: currentQuestionIndex)
        }
    }
    
    // Handle "Previous" button tap
    @objc func previousQuestion() {
        resultLabel.text = ""
        resultLabel.textColor = .white
        submitButton.isEnabled = true
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            showQuestion(at: currentQuestionIndex)
        }
    }
    
    @objc func submitAnswer() {
        guard let selectedIndex = selectedAnswerIndex else {
            debugPrint("No answer selected")
            return
        }
        
        let selectedAnswer = questions[currentQuestionIndex].answers[selectedIndex]
        
        // Check if the selected answer is correct
        if selectedAnswer.isCorrect {
            resultLabel.text = "Correct Answer"
            resultLabel.textColor = .green
            submitButton.isEnabled = false
        } else {
            resultLabel.text = "Incorrect Answer"
            resultLabel.textColor = .red
        }
    }
    
    
    
}
