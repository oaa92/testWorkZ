//
//  FullNameSection.swift
//  testWorkZx
//
//  Created by Анатолий on 08/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Eureka

class FullNameSection: Section {
    var lastName: String {
        get {
            return (allRows[0] as? TextRow)?.value ?? ""
        }
        set {
            (allRows[0] as? TextRow)?.value = newValue
        }
    }
    
    var firstName: String {
        get {
            return (allRows[1] as? TextRow)?.value ?? ""
        }
        set {
            (allRows[1] as? TextRow)?.value = newValue
        }
    }
    
    var secondName: String {
        get {
            return (allRows[2] as? TextRow)?.value ?? ""
        }
        set {
            (allRows[2] as? TextRow)?.value = newValue
        }
    }
    
    func setupRows() {
        let lastNameKey = RowTag.lastName.rawValue
        let firstNameKey = RowTag.firstName.rawValue
        let secondNameKey = RowTag.secondName.rawValue
        self
        <<< TextRow(prefixForRowTag + lastNameKey){
            let text = NSLocalizedString(lastNameKey, comment: "")
            $0.title = text.capitalizingFirstLetter()
            $0.placeholder = text
            $0.add(rule: RuleRequired())
        }
        <<< TextRow(prefixForRowTag + firstNameKey){
            let text = NSLocalizedString(firstNameKey, comment: "")
            $0.title = text.capitalizingFirstLetter()
            $0.placeholder = text
        }
        <<< TextRow(prefixForRowTag + secondNameKey){
            let text = NSLocalizedString(secondNameKey, comment: "")
            $0.title = text.capitalizingFirstLetter()
            $0.placeholder = text
        }
        
        for case let row as TextRow in allRows {
            row.add(rule: RuleRequired())
            row.validationOptions = .validatesOnChange
            row.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .systemRed
                }
            }
        }
    }
}
