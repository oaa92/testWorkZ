//
//  EmployeesTableView.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class EmployeesTableView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(tableView)
    }
    
    private func setupConstrains() {
        let tableViewConstrains = [tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                   tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                                   tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                                   tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(tableViewConstrains)
    }
}
