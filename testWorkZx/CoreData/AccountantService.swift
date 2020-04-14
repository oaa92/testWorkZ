//
//  AccountantService.swift
//  testWorkZx
//
//  Created by Анатолий on 09/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData

extension AccountantType {
    var localized: String {
        return NSLocalizedString(name!, comment: "")
    }
}

class AccountantService: ServiceFetchProtocol  {
    typealias T = Accountant
    var context: NSManagedObjectContext!
    
    init() {}
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTypes() -> [AccountantType]? {
        let fetchRequest: NSFetchRequest<AccountantType> = AccountantType.fetchRequest()
        let types = try? context.fetch(fetchRequest)
        return types
    }

    func fetchType(by name: String) -> AccountantType? {
        let fetchRequest: NSFetchRequest<AccountantType> = AccountantType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(AccountantType.name), name)
        let types = try? context.fetch(fetchRequest)
        return types?.first
    }
}
