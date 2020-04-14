//
//  EmployeeViewController+Load.swift
//  testWorkZx
//
//  Created by Анатолий on 10/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData
import Eureka

// MARK: Update UI

extension EmployeeViewController {
    func updateUI() {
        guard let employee = employee,
            let employeeTypeRow: SegmentedRow<String> = form.rowBy(tag: RowTag.positionRow.rawValue) else {
            return
        }

        switch employee {
        case is Lead:
            employeeTypeRow.value = Lead.localized
        case is Accountant:
            employeeTypeRow.value = Accountant.localized
        case is Employee:
            employeeTypeRow.value = Employee.localized
        default:
            return
        }

        updateCommonInfo()
        updateLeadInfo()
        updateEmployeeInfo()
        updateAccountantInfo()
    }
    
    private func updateCommonInfo() {
        guard let employee = employee else {
            return
        }
        
        if let fullNameSection = form.sectionBy(tag: SectionTag.fullName.rawValue) as? FullNameSection {
            fullNameSection.lastName = employee.lastName ?? ""
            fullNameSection.firstName = employee.firstName ?? ""
            fullNameSection.secondName = employee.secondName ?? ""
        }

        if let salarySection = form.sectionBy(tag: SectionTag.salary.rawValue)?.first as? IntRow {
            salarySection.value = Int(employee.salary)
        }
    }

    private func updateLeadInfo() {
        guard let employee = employee as? Lead else {
            return
        }
                
        if let meeting = employee.meeting,
            let consultingSection = form.sectionBy(tag: SectionTag.consultingHours.rawValue) as? TimeSection {
            consultingSection.from = meeting.start
            consultingSection.to = meeting.end
        }
    }

    private func updateEmployeeInfo() {
        guard let employee = employee as? Employee else {
            return
        }
        
        (form.sectionBy(tag: SectionTag.workplace.rawValue)?.first as? IntRow)?.value = Int(employee.workplace)
        if let lunchTime = employee.lunchTime,
            let lunchSection = form.sectionBy(tag: SectionTag.lunchTime.rawValue) as? TimeSection {
            lunchSection.from = lunchTime.start
            lunchSection.to = lunchTime.end
        }
    }
    
    private func updateAccountantInfo() {
        guard let employee = employee as? Accountant else {
            return
        }
        
        if let type = employee.type,
            let departmentRow = (form.sectionBy(tag: SectionTag.accountingDepartment.rawValue)?.first as? PickerInputRow<String>) {
            departmentRow.value = type.localized
        }
    }
}
