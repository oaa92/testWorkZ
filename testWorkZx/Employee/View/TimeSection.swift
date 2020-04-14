//
//  TimeSection.swift
//  testWorkZx
//
//  Created by Анатолий on 08/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Eureka

class TimeSection: Section {
    var from: Date? {
        get {
            return (allRows[0] as? TimeRow)?.value
        }
        set {
            (allRows[0] as? TimeRow)?.value = newValue
        }
    }
    
    var to: Date? {
        get {
            return (allRows[1] as? TimeRow)?.value
        }
        set {
            (allRows[1] as? TimeRow)?.value = newValue
        }
    }
    
    func setupRows() {
        let fromKey = RowTag.from.rawValue
        let toKey = RowTag.to.rawValue
        self
        <<< TimeRow(prefixForRowTag + fromKey) {
            $0.title = NSLocalizedString(fromKey, comment: "").capitalizingFirstLetter()
        }
        <<< TimeRow(prefixForRowTag + toKey) {
            $0.title = NSLocalizedString(toKey, comment: "").capitalizingFirstLetter()
        }
    }
}
