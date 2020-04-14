//
//  RoverCamera.swift
//  testWorkZx
//
//  Created by Анатолий on 14/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

enum RoverCamera: String {
    case FHAZ       //Front Hazard Avoidance Camera
    case NAVCAM     //Navigation Camera
    case PANCAM     //Panoramic Camera
    case MINITES    //Miniature Thermal Emission Spectrometer (Mini-TES)
    case ENTRY      //Entry, Descent, and Landing Camera
    case RHAZ       //Rear Hazard Avoidance Camera
}

extension RoverCamera: Decodable {
    enum CodingKeys: String, CodingKey {
        case rawValue = "name"
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        if let value = RoverCamera(rawValue: rawValue) {
            self = value
        } else {
            throw CodingError.unknownValue
        }
    }
}
