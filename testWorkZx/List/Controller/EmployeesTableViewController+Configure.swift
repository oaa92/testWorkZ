//
//  EmployeesTableViewController+Configure.swift
//  testWorkZx
//
//  Created by Анатолий on 10/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import UIKit

// MARK: Configure cell

extension EmployeesTableViewController {
    func configure(_ cell: UITableViewCell, by indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        cell.imageView?.image = UIImage(named: "employees")
        cell.imageView?.tintColor = .darkGray
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.numberOfLines = 0

        let employee = listData[indexPath.section][indexPath.row]
        
        let fullName = employee.fullName
        cell.textLabel?.text = fullName
        
        var detailText = ""
        detailText.append(getSalaryInfo(employee))
        detailText.append(getLeadInfo(employee))
        detailText.append(getEmployeeInfo(employee))
        detailText.append(getAccountantInfo(employee))
        
        cell.detailTextLabel?.text = detailText
    }
    
    private func getSalaryInfo(_ employee: AbstractEmployee) -> String {
        var detailText = ""
        let salary = employee.salary
        if salary > 0 {
            addInfo(to: &detailText,
                    title: NSLocalizedString(SectionTag.salary.rawValue, comment: ""),
                    value: String(salary))
        }
        return detailText
    }
    
    private func getLeadInfo(_ employee: AbstractEmployee) -> String {
        var detailText = ""
        if let employee = employee as? Lead {
            if let consultingHoursInfo = generateTimeIntervalInfo(time: employee.meeting) {
                addInfo(to: &detailText,
                        title: NSLocalizedString(SectionTag.consultingHours.rawValue, comment: ""),
                        value: consultingHoursInfo)
            }
        }
        return detailText
    }
    
    private func getEmployeeInfo(_ employee: AbstractEmployee) -> String {
        var detailText = ""
        if let employee = employee as? Employee {
            let workplace = employee.workplace
            if workplace > 0 {
                addInfo(to: &detailText,
                        title: NSLocalizedString(SectionTag.workplace.rawValue, comment: ""),
                        value: String(workplace))
            }

            if let lunchTimeInfo = generateTimeIntervalInfo(time: employee.lunchTime) {
                addInfo(to: &detailText,
                        title: NSLocalizedString(SectionTag.lunchTime.rawValue, comment: ""),
                        value: lunchTimeInfo)
            }
        }
        return detailText
    }
    
    private func getAccountantInfo(_ employee: AbstractEmployee) -> String {
        var detailText = ""
        if let employee = employee as? Accountant {
            if let type = employee.type {
                addInfo(to: &detailText,
                        title: NSLocalizedString(SectionTag.accountingDepartment.rawValue, comment: ""),
                        value: type.localized)
            }
        }
        return detailText
    }

    private func generateTimeIntervalInfo(time: TimeInterval?) -> String? {
        guard let time = time else {
            return nil
        }
        if let from = time.start,
            let to = time.end {
            let fromStr = DateFormatter.localizedString(from: from, dateStyle: .none, timeStyle: .short)
            let toStr = DateFormatter.localizedString(from: to, dateStyle: .none, timeStyle: .short)
            let text = fromStr + " - " + toStr
            return text
        }
        return nil
    }

    private func addInfo(to: inout String, title: String, value: String) {
        to.append(title + ": " + value + "\n")
    }
}
