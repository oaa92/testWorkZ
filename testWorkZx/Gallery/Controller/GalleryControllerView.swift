//
//  GalleryControllerView.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

class GalleryControllerView: CustomViewController<GalleryView> {
    let urlService = URLServiceWithCache()
    private var imageUrls: [String] = []
    private var currentPage = 0
    private var pages = [ImageScrollView?]()
    private var initialPagesIsSetup = false
    private var numPages: Int {
        return imageUrls.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("gallery", comment: "").capitalizingFirstLetter()
        let back = UIBarButtonItem(title: NSLocalizedString("back", comment: ""),
                                   style: .plain,
                                   target: self,
                                   action: #selector(self.back))
        let forward = UIBarButtonItem(title: NSLocalizedString("forward", comment: ""),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.forward))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        customView.toolBar.items = [back, space, forward]
        customView.toolBar.sizeToFit()
        customView.scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPages()
    }
    
    // MARK: - Utilities
    
    private func adjustScrollView() {
        customView.scrollView.contentSize =
            CGSize(width: customView.scrollView.frame.width * CGFloat(numPages),
                   height: customView.scrollView.frame.height)
    }
    
    private func removePages(exceptPage: Int?) {
        for (index, page) in pages.enumerated() {
            if let exceptPage = exceptPage,
                abs(exceptPage - index) < 2 {
                continue
            }
            page?.image = nil
            page?.removeFromSuperview()
            pages[index] = nil
        }
    }
    
    // MARK: - Page Loading
    
    private func loadCurrentPages(page: Int) {
        guard 0..<numPages ~= page else { return }
        // Load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling).
        
        removePages(exceptPage: page)
        
        loadPage(Int(page) - 1)
        loadPage(Int(page))
        loadPage(Int(page) + 1)
        
        currentPage = Int(page)
    }
    
    private func gotoPage(page: Int) {
        guard 0..<numPages ~= page else { return }
        loadCurrentPages(page: page)
        
        var bounds = customView.scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        customView.scrollView.bounds = bounds
    }
}

// MARK: - Actions

extension GalleryControllerView {
    @objc func back() {
        gotoPage(page: currentPage - 1)
    }
    
    @objc func forward() {
        gotoPage(page: currentPage + 1)
    }
}

// MARK: - Transitioning

extension GalleryControllerView {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        removePages(exceptPage: nil)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.adjustScrollView()
            self.gotoPage(page: self.currentPage)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: - UIScrollViewDelegate

extension GalleryControllerView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingStopped()
    }
    
    func scrollingStopped() {
        let pageWidth = customView.scrollView.frame.width
        let page: Int = Int(floor((customView.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        if page != currentPage {
            loadCurrentPages(page: page)
        }
    }
}

// MARK: - Get URLs for images

extension GalleryControllerView {
    private func loadPages() {
        guard !initialPagesIsSetup else {
            return
        }
        
        let apikey = "QcnGcAt5JceS9nf3P4ISoGjyTMbakRrIjNeKIy1H"
        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?sol=951&api_key=\(apikey)"
        urlService.downloadContent(url: url) {
            result in
            switch result {
            case let .success(_, data):
                guard let roverResponse = try? JSONDecoder().decode(RoverResponse.self, from: data) else {
                    return
                }
                let cameras: Set<RoverCamera> = [.FHAZ, .RHAZ, .PANCAM]
                let photos = roverResponse.photos.filter { cameras.contains($0.camera) }
                let urls: [String] = photos.compactMap {
                    if var urlComponents = URLComponents(string: $0.url) {
                        if urlComponents.scheme == "http" {
                            urlComponents.scheme = "https"
                        }
                        if let url = urlComponents.string {
                            return url
                        } else {
                            return nil
                        }
                    }
                    return nil
                }
                DispatchQueue.main.async {
                    self.imageUrls = urls
                    self.pages = [ImageScrollView?](repeating: nil, count: self.numPages)
                    self.adjustScrollView()
                    self.loadPage(0)
                    self.loadPage(1)
                    self.initialPagesIsSetup = true
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Load page

extension GalleryControllerView {
    private func loadPage(_ page: Int) {
        guard 0..<numPages ~= page else { return }
        if let page = pages[page] {
            page.zoomScale = page.minimumZoomScale
            return
        }
        createPage(page)
        
        urlService.downloadContent(url: imageUrls[page]) {
            result in
            switch result {
            case let .success(_, data):
                if let image = UIImage(data: data) {
                    let img = self.drawPageNumberInImage(image: image, page: page)
                    DispatchQueue.main.async {
                        self.pages[page]?.image = img
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createPage(_ page: Int) {
        let imageScrollView = ImageScrollView()
        imageScrollView.frame.size.height = customView.scrollView.frame.height
        imageScrollView.frame.size.width = customView.scrollView.frame.width - customView.space
        imageScrollView.frame.origin.x = customView.scrollView.frame.width * CGFloat(page)
        imageScrollView.frame.origin.y = 0
        customView.scrollView.insertSubview(imageScrollView, at: 0)
        pages[page] = imageScrollView
    }
    
    private func drawPageNumberInImage(image: UIImage, page: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let img = renderer.image { _ in
            image.draw(at: .zero)
            let attributedString = NSAttributedString(string: String(page),
                                                      attributes: [
                                                          .font: UIFont.systemFont(ofSize: 25),
                                                          .foregroundColor: UIColor.blue
                                                      ])
            attributedString.draw(at: .zero)
        }
        return img
    }
}
