//
//  EmployeesTableViewController.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData
import UIKit

class EmployeesTableViewController: CustomViewController<EmployeesTableView> {
    var coreDataStack: CoreDataStack!
    var listData: [[AbstractEmployee]] = []
    private let cellID = "employeeCellID"
    private var sectionHeaders: [String] = []

    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(addEmployeeAction))

    lazy var sortButton = UIBarButtonItem(image: UIImage(named: "sort"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(sortAction))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("list", comment: "").capitalizingFirstLetter()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItems = [sortButton, addButton]
        loadData()
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        customView.tableView.setEditing(editing, animated: animated)
        let items: [UIBarButtonItem]? = editing ? nil : [sortButton, addButton]
        navigationItem.setRightBarButtonItems(items, animated: true)
    }
}

// MARK: Actions

extension EmployeesTableViewController {
    @objc func addEmployeeAction() {
        pushEmployeeController(employee: nil)
    }
    
    @objc func sortAction() {
        for i in 0..<listData.count where listData[i].count > 0 {
            listData[i].sort { $0.fullName < $1.fullName }
            actualizeIndexes(section: i, range: 0...listData[i].count - 1)
            customView.tableView.reloadSections([i], with: .automatic)
        }
    }

    func pushEmployeeController(employee: AbstractEmployee?) {
        let employeeController = EmployeeViewController()
        employeeController.coreDataStack = coreDataStack
        employeeController.employee = employee
        employeeController.delegate = self
        navigationController?.pushViewController(employeeController, animated: true)
    }
}

// MARK: Load data

extension EmployeesTableViewController {
    func loadData() {
        let employeeService = EmployeeService(coreDataStack.managedContext)
        listData.append(employeeService.fetchWithSortByIndex() ?? [])
        sectionHeaders.append(Employee.localized)

        let accountantService = AccountantService(coreDataStack.managedContext)
        listData.append(accountantService.fetchWithSortByIndex() ?? [])
        sectionHeaders.append(Accountant.localized)

        let leadService = LeadService(coreDataStack.managedContext)
        listData.append(leadService.fetchWithSortByIndex() ?? [])
        sectionHeaders.append(Lead.localized)
    }
}

// MARK: UITableViewDataSource

extension EmployeesTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        configure(cell, by: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let employee = listData[sourceIndexPath.section][sourceIndexPath.row]
        moveEmployee(employee, from: sourceIndexPath, to: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard sourceIndexPath.section == proposedDestinationIndexPath.section else {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}

// MARK: UITableViewDelegate

extension EmployeesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = listData[indexPath.section][indexPath.row]
        pushEmployeeController(employee: employee)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let employee = listData[indexPath.section][indexPath.row]
            coreDataStack.managedContext.delete(employee)
            coreDataStack.saveContext()

            deleteEmployee(section: indexPath.section, index: indexPath.row)
        }
    }
}

// MARK: EmployeeEditProtocol

extension EmployeesTableViewController: EmployeeEditProtocol {
    func employeeDidChange(employee: AbstractEmployee) {
        guard let section = findSection(employee) else {
            return
        }

        let index = Int(employee.indexInList)
        if listData[section].count > index,
            listData[section][index] == employee {
            updateEmployee(employee, at: IndexPath(row: index, section: index))
        } else {
            addEmployee(employee, to: section)
        }
    }

    func employeeDidDeleted(employee: AbstractEmployee) {
        guard let section = findSection(employee) else {
            return
        }

        let index = Int(employee.indexInList)
        deleteEmployee(section: section, index: index)
    }
}

// MARK: Update cells in tableView

extension EmployeesTableViewController {
    enum EmployeeChangeType {
        case insert
        case delete
        case update
    }

    private func findSection(_ employee: AbstractEmployee) -> Int? {
        switch employee {
        case is Lead:
            return 2
        case is Accountant:
            return 1
        case is Employee:
            return 0
        default:
            return nil
        }
    }

    private func actualizeIndexes(section: Int, range: CountableClosedRange<Int>) {
        for i in range {
            let employee = listData[section][i]
            employee.indexInList = Int64(i)
        }
        coreDataStack.saveContext()
    }

    private func addEmployee(_ employee: AbstractEmployee, to section: Int) {
        let index = listData[section].count
        employee.indexInList = Int64(index)
        listData[section].append(employee)
        tableViewDidChangedContent(at: IndexPath(row: index, section: section), type: .insert)
    }

    private func updateEmployee(_ employee: AbstractEmployee, at indexPath: IndexPath) {
        tableViewDidChangedContent(at: indexPath, type: .update)
    }

    private func deleteEmployee(section: Int, index: Int) {
        listData[section].remove(at: index)

        if index < listData[section].count {
            let range: ClosedRange = index...listData[section].count - 1
            actualizeIndexes(section: section, range: range)
        }

        tableViewDidChangedContent(at: IndexPath(row: index, section: section), type: .delete)
    }

    private func moveEmployee(_ employee: AbstractEmployee, from: IndexPath, to: IndexPath) {
        let section = from.section
        let index = Int(employee.indexInList)
        let newIndex = to.row

        listData[section].remove(at: index)
        listData[section].insert(employee, at: newIndex)

        let range: ClosedRange = min(index, newIndex)...max(index, newIndex)
        actualizeIndexes(section: section, range: range)
    }

    private func tableViewDidChangedContent(at indexPath: IndexPath,
                                            to newIndexPath: IndexPath? = nil,
                                            type: EmployeeChangeType) {
        let tableView = customView.tableView
        tableView.beginUpdates()
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            if let cell = tableView.cellForRow(at: indexPath) {
                configure(cell, by: indexPath)
            }
        }
        tableView.endUpdates()
    }
}
