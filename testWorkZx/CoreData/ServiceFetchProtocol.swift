//
//  ServiceFetchProtocol.swift
//  testWorkZx
//
//  Created by Анатолий on 10/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData

protocol ServiceFetchProtocol {
    associatedtype T: AbstractEmployee
    var context: NSManagedObjectContext! {get set}
    func fetchWithSortByIndex() -> [T]?
}

extension ServiceFetchProtocol {
    func fetchWithSortByIndex() -> [T]? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: T.description())
        fetchRequest.propertiesToFetch = ["indexInList"]
        if var res = try? context.fetch(fetchRequest) {
            res = res
                .filter { type(of: $0) == T.self }
                .sorted { $0.indexInList < $1.indexInList }
            return res
        }
        return nil
    }
}
