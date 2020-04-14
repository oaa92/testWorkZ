//
//  QuoteList.swift
//  testWorkZx
//
//  Created by Анатолий on 14/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

struct QuoteList: Decodable {
    let total: Int
    let last: String
    let quotes: [Quote]
}
