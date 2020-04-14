//
//  EmployeeService.swift
//  testWorkZx
//
//  Created by Анатолий on 09/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData

class EmployeeService: ServiceFetchProtocol {
    typealias T = Employee
    var context: NSManagedObjectContext!
    
    init() {}
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
        
    func setLunchTime(to employee: Employee, from: Date, to: Date) {
        let lt = employee.lunchTime ?? TimeInterval(context: context)
        lt.start = from
        lt.end = to
        employee.lunchTime = lt
    }
}


