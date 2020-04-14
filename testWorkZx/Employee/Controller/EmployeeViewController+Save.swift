//
//  EmployeeViewController+Save.swift
//  testWorkZx
//
//  Created by Анатолий on 10/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData
import Eureka

// MARK: Save data

extension EmployeeViewController {
    @objc func saveEmployee() {
        guard formIsValid() else {
            return
        }

        let context = coreDataStack.managedContext

        createEntityIfNeeded(context)

        guard let employee = employee else {
            return
        }

        setCommonPart(employee)
        setEmployeePart(employee, in: context)
        setAccountantPart(employee, in: context)
        setLeadPart(employee, in: context)
        coreDataStack.saveContext()

        if let delegate = delegate {
            delegate.employeeDidChange(employee: employee)
        }
    }

    private func formIsValid() -> Bool {
        form.validate()
        for section in form.allSections {
            for row in section.allRows {
                if !row.isValid {
                    let message = NSLocalizedString("requiredFieldsAreNotFilled", comment: "").capitalizingFirstLetter()
                    let cancelTxt = NSLocalizedString("cancel", comment: "").capitalizingFirstLetter()
                    let errorTxt = NSLocalizedString("error", comment: "").capitalizingFirstLetter()
                    let alert = UIAlertController(title: errorTxt,
                                                  message: message,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: cancelTxt,
                                                  style: .cancel,
                                                  handler: nil))
                    present(alert, animated: true)
                    return false
                }
            }
        }
        return true
    }

    private func createEntityIfNeeded(_ context: NSManagedObjectContext) {
        guard let employeeTypeRow: SegmentedRow<String> = form.rowBy(tag: RowTag.positionRow.rawValue) else {
            return
        }

        // employee is created and type not changed
        let value = employeeTypeRow.value
        if value == Accountant.localized && type(of: employee) == Accountant.self ||
            value == Employee.localized && type(of: employee) == Employee.self ||
            value == Lead.localized && type(of: employee) == Lead.self {
            return
        }

        // new employee or type changed
        switch value {
        case Employee.localized:
            createEmployee(context, type: Employee.description())
        case Accountant.localized:
            createEmployee(context, type: Accountant.description())
        case Lead.localized:
            createEmployee(context, type: Lead.description())
        default:
            break
        }
    }

    private func createEmployee(_ context: NSManagedObjectContext, type: String) {
        if let employee = self.employee {
            context.delete(employee)
            if let delegate = delegate {
                delegate.employeeDidDeleted(employee: employee)
            }
        }
        if let description = NSEntityDescription.entity(forEntityName: type, in: context) {
            employee = NSManagedObject(entity: description, insertInto: context) as? AbstractEmployee
        }
    }

    private func setCommonPart(_ employee: AbstractEmployee) {
        if let fullNameSection = form.sectionBy(tag: SectionTag.fullName.rawValue) as? FullNameSection {
            employee.lastName = fullNameSection.lastName
            employee.firstName = fullNameSection.firstName
            employee.secondName = fullNameSection.secondName
        }
        employee.salary = Int32((form.sectionBy(tag: SectionTag.salary.rawValue)?.first as? IntRow)?.value ?? 0)
    }

    private func setEmployeePart(_ employee: AbstractEmployee, in context: NSManagedObjectContext) {
        guard let employee = employee as? Employee else {
            return
        }

        employee.workplace = Int16((form.sectionBy(tag: SectionTag.workplace.rawValue)?.first as? IntRow)?.value ?? 0)

        let service = EmployeeService(context)

        if let lunchSection = form.sectionBy(tag: SectionTag.lunchTime.rawValue) as? TimeSection,
            let from = lunchSection.from,
            let to = lunchSection.to {
            service.setLunchTime(to: employee, from: from, to: to)
        }
    }

    private func setLeadPart(_ employee: AbstractEmployee, in context: NSManagedObjectContext) {
        guard let employee = employee as? Lead else {
            return
        }

        let service = LeadService(context)

        if let consultingSection = form.sectionBy(tag: SectionTag.consultingHours.rawValue) as? TimeSection,
            let from = consultingSection.from,
            let to = consultingSection.to {
            service.setMeetingTime(to: employee, from: from, to: to)
        }
    }

    private func setAccountantPart(_ employee: AbstractEmployee, in context: NSManagedObjectContext) {
        guard let employee = employee as? Accountant,
            let value = (form.sectionBy(tag: SectionTag.accountingDepartment.rawValue)?.first as? PickerInputRow<String>)?.value else {
            return
        }

        let service = AccountantService(context)
        if let types = service.fetchTypes(),
            let type = types.first(where: { $0.localized == value }) {
            employee.type = type
        }
    }
}
