//
//  LocalizedEntity.swift
//  testWorkZx
//
//  Created by Анатолий on 09/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData

protocol LocalizedEntity: NSManagedObject {
    static var localized: String {get}
}

extension LocalizedEntity {
    static var localized: String {
        return NSLocalizedString(Self.description().lowercased(), comment: "")
    }
}
