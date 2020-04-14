//
//  Quote.swift
//  testWorkZx
//
//  Created by Анатолий on 14/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

struct Quote: Decodable {
    let id: Int
    let description: String
    let time: String
    let rating: Int
}
