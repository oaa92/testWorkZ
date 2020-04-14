//
//  EmployeeViewController.swift
//  testWorkZx
//
//  Created by Анатолий on 07/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData
import Eureka

class EmployeeViewController: FormViewController {
    var coreDataStack: CoreDataStack!
    var employee: AbstractEmployee?
    weak var delegate: EmployeeEditProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveEmployee))
        setupForm()
        updateUI()
    }
}
