//
//  AnswerCell.swift
//  InterviewGuide
//
//  Created by Naveen Keerthy on 10/22/24.
//

import UIKit

class AnswerCell: UITableViewCell {
    let answerLabel = UILabel()
    let radioButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        // Configure the label for answer text
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.numberOfLines = 0
        
        // Configure the radio button
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal) // Unselected state
        radioButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected) // Selected state
        radioButton.isUserInteractionEnabled = false // Prevent direct interaction
        
        contentView.addSubview(answerLabel)
        contentView.addSubview(radioButton)
        
        // Set up constraints for both the radio button and the label
        NSLayoutConstraint.activate([
            // Radio button constraints
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Answer label constraints
            answerLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 16),
            answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            answerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with answerText: String, isSelected: Bool) {
        answerLabel.text = answerText
        radioButton.isSelected = isSelected // Update radio button selection state
    }
}
