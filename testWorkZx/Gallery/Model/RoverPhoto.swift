//
//  RoverPhoto.swift
//  testWorkZx
//
//  Created by Анатолий on 14/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

struct RoverPhoto: Equatable {
    let id: Int
    let url: String
    let camera: RoverCamera
}

extension RoverPhoto: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case url = "img_src"
        case camera
    }
}
