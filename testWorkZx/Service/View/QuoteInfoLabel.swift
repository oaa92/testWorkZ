//
//  QuoteInfoLabel.swift
//  testWorkZx
//
//  Created by Анатолий on 14/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class QuoteInfoLabel: UILabel {
    var fontSize: CGFloat {
        get {
            return font.pointSize
        }
        set {
            font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        font = UIFont.systemFont(ofSize: 13)
        textColor = .darkGray
    }
}
