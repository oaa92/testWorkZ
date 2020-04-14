//
//  GalleryView.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class GalleryView: UIView {
    let space: CGFloat = 10
    
    let toolBar: UIToolbar = {
        let frame: CGRect
        if #available(iOS 13, *) {
            frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        } else {
            frame = .zero
        }
        let toolbar = UIToolbar(frame: frame)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.backgroundColor = UIColor(white: 0.95, alpha: 0.5)
        return toolbar
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scrollView)
        addSubview(toolBar)
    }
    
    private func setupConstrains() {
        let constrains = [scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                          scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                          scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: space),
                          scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(constrains)
        
        let toolVarConstrains = [toolBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                                 toolBar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                                 toolBar.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)]
        NSLayoutConstraint.activate(toolVarConstrains)
    }
}
