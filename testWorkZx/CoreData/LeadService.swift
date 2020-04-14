//
//  LeadService.swift
//  testWorkZx
//
//  Created by Анатолий on 09/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData

class LeadService: ServiceFetchProtocol {    
    typealias T = Lead
    var context: NSManagedObjectContext!
    
    init() {}
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
        
    func setMeetingTime(to lead: Lead, from: Date, to: Date) {
        let lt = lead.meeting ?? TimeInterval(context: context)
        lt.start = from
        lt.end = to
        lead.meeting = lt
    }
}
