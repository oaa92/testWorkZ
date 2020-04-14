//
//  ServiceView.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class ServiceView: UIView {
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
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
        addSubview(activityIndicatorView)
    }
    
    private func setupConstrains() {
        let indicatorConstrains = [activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                   activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)]
        NSLayoutConstraint.activate(indicatorConstrains)
        
        let tableViewConstrains = [tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                   tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                                   tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                                   tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(tableViewConstrains)
    }
}
