//
//  ImageScrollView.swift
//  testWorkZx
//
//  Created by Анатолий on 12/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView {
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.removeFromSuperview()
            guard let image = newValue else {
                return
            }
            imageView = UIImageView(image: image)
            addSubview(imageView)
            contentSize = image.size
            updateScales()
        }
    }
    
    private var imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }
    
    private func setupView() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func updateScales() {
        setMinMaxZoomScale()
        zoomScale = minimumZoomScale
    }
    
    private func setMinMaxZoomScale() {
        let xScale = bounds.width / imageView.bounds.width
        let yScale = bounds.height / imageView.bounds.height
        let minScale = min(xScale, yScale)
        minimumZoomScale = minScale
        maximumZoomScale = max(1.0, minScale * 2)
    }
    
    private func centerImage() {
        var frame = imageView.frame
        frame.origin.x = frame.width < bounds.width ? (bounds.width - frame.width) / 2 : 0
        frame.origin.y = frame.height < bounds.height ? (bounds.height - frame.height) / 2 : 0
        imageView.frame = frame
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
