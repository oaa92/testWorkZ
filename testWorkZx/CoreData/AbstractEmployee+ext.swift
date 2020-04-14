//
//  AbstractEmployee+ext.swift
//  testWorkZx
//
//  Created by Анатолий on 11/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

extension AbstractEmployee: LocalizedEntity {
    var fullName: String {
        return [lastName, firstName, secondName].compactMap { $0 }.joined(separator: " ")
    }
}
