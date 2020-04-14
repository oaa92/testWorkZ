//
//  ServiceViewController.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class ServiceViewController: CustomViewController<ServiceView> {
    var data: QuoteList?
    let reuseID = "quoteCellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("service", comment: "").capitalizingFirstLetter()
        customView.tableView.register(QuoteCell.self, forCellReuseIdentifier: reuseID)
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        loadQuote()
    }
}

// MARK: UITableViewDataSource

extension ServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.quotes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? QuoteCell else {
            fatalError("Could not dequeue cell with identifier: \(reuseID)")
        }
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
}

// MARK: UITableViewDelegate

extension ServiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: Table cell configuration

extension ServiceViewController {
    func configure(cell: QuoteCell, indexPath: IndexPath) {
        guard let data = data,
            data.quotes.indices.contains(indexPath.row) else {
            return
        }

        let quote = data.quotes[indexPath.row]
        let description = quote.description
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "<br>", with: "\n")

        cell.idLabel.text = String(quote.id)
        cell.dateLabel.text = quote.time
        cell.quoteView.text = description
        cell.ratingLabel.text = NSLocalizedString("rating", comment: "").capitalizingFirstLetter() + ": \(String(quote.rating))"
    }
}

extension ServiceViewController {
    func loadQuote() {
        guard let url = URL(string: "http://quotes.zennex.ru/api/v3/bash/quotes?sort=time") else {
            return
        }

        customView.tableView.isHidden = true
        customView.activityIndicatorView.startAnimating()

        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: url) {
            (result: Result<(URLResponse, Data), Error>) in
            switch result {
                case let .success((_, data)):
                    guard let response = try? JSONDecoder().decode(QuoteList.self, from: data) else {
                        break
                    }
                    DispatchQueue.main.async {
                        self.data = response
                        self.customView.tableView.reloadData()
                    }
                case let .failure(error):
                    print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.customView.activityIndicatorView.stopAnimating()
                self.customView.tableView.isHidden = false
            }
        }.resume()
    }
}
