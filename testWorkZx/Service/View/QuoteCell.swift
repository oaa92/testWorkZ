//
//  QuoteCell.swift
//  testWorkZx
//
//  Created by Анатолий on 14/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let idLabel = QuoteInfoLabel()
    
    let dateLabel: UILabel = QuoteInfoLabel()
    
    let quoteView: UITextView = {
        let quoteView = UITextView()
        quoteView.isUserInteractionEnabled = false
        quoteView.isScrollEnabled = false
        quoteView.backgroundColor = .clear
        quoteView.font = UIFont.systemFont(ofSize: 17)
        quoteView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        quoteView.textContainer.lineFragmentPadding = 0
        return quoteView
    }()
    
    let ratingLabel = QuoteInfoLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        setupHeaderStack()
        stack.addArrangedSubview(quoteView)
        stack.addArrangedSubview(ratingLabel)
        addSubview(stack)
    }
    
    private func setupHeaderStack() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        
        stack.addArrangedSubview(idLabel)
        stack.addArrangedSubview(dateLabel)
        self.stack.addArrangedSubview(stack)
    }
    
    private func setupConstrains() {
        let constrains = [stack.topAnchor.constraint(equalTo: topAnchor),
                          stack.leadingAnchor.constraint(equalTo: leadingAnchor),
                          stack.trailingAnchor.constraint(equalTo: trailingAnchor),
                          stack.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(constrains)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = ""
        dateLabel.text = ""
        quoteView.text = ""
        ratingLabel.text = ""
    }
}
