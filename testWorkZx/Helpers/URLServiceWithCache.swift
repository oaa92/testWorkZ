//
//  URLServiceWithCache.swift
//  testWorkZx
//
//  Created by Анатолий on 13/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

class URLServiceWithCache {
    lazy var cache: URLCache = {
        let capacity = 128 * 1024 * 1024
        let cache: URLCache
        if #available(iOS 13.0, *) {
            cache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, directory: nil)
        } else {
            cache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
        }
        return cache
    }()

    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cache
        return URLSession(configuration: sessionConfiguration)
    }

    func downloadContent(url: String,
                         completionHandler: @escaping (Result<(URLResponse, Data), Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let cachedData = self.cache.cachedResponse(for: urlRequest) {
                completionHandler(.success((cachedData.response, cachedData.data)))
            } else {
                self.createAndRetrieveURLSession().dataTask(with: url) {
                    (result: Result<(URLResponse, Data), Error>) in
                    switch result {
                    case let .failure(error):
                        completionHandler(.failure(error))
                    case let .success((response, data)):
                        let cachedData = CachedURLResponse(response: response, data: data)
                        self.cache.storeCachedResponse(cachedData, for: urlRequest)
                        completionHandler(.success((response, data)))
                    }
                }.resume()
            }
        }
    }
}
