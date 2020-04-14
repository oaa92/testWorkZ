//
//  EmployeeEditProtocol.swift
//  testWorkZx
//
//  Created by Анатолий on 07/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Foundation

protocol EmployeeEditProtocol: class {
    func employeeDidChange(employee: AbstractEmployee)
    func employeeDidDeleted(employee: AbstractEmployee)
}
