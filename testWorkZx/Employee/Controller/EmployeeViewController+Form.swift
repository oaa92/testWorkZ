//
//  EmployeeViewController+Form.swift
//  testWorkZx
//
//  Created by Анатолий on 10/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import Eureka

// MARK: Generate form

extension EmployeeViewController {
    func setupForm() {
        form
            +++ createSection(tag: .position)
    }

    private func updateForm(row: SegmentedRow<String>) {
        let tags = getSectionTagsForEmployeeType(value: row.value)
        removeSections(tagsNeeded: tags)
        appendSections(tagsNeeded: tags)
    }

    private func getSectionTagsForEmployeeType(value: String?) -> [SectionTag] {
        var sections: [SectionTag] = [.position, .fullName, .salary]
        switch value {
        case Lead.localized:
            sections.append(.consultingHours)
        case Employee.localized, Accountant.localized:
            sections.append(contentsOf: [.workplace, .lunchTime])
            if value == Accountant.localized {
                sections.append(.accountingDepartment)
            }
        default:
            break
        }
        return sections
    }

    private func removeSections(tagsNeeded: [SectionTag]) {
        for section in form.allSections {
            if let tag = section.tag,
                let index = section.index,
                !tagsNeeded.contains(where: { $0.rawValue == tag }) {
                form.remove(at: index)
            }
        }
    }

    private func appendSections(tagsNeeded: [SectionTag]) {
        for tag in tagsNeeded {
            if form.sectionBy(tag: tag.rawValue) == nil {
                let section = createSection(tag: tag)
                form.append(section)
            }
        }
    }

    private func createSection(tag: SectionTag) -> Section {
        switch tag {
        case .position:
            let key = SectionTag.position.rawValue
            let positionSection = Section(NSLocalizedString(key, comment: "").capitalizingFirstLetter()) {
                $0.tag = key
            }
            positionSection
                <<< SegmentedRow<String>() {
                    $0.tag = RowTag.positionRow.rawValue
                    $0.options = [Employee.localized,
                                  Accountant.localized,
                                  Lead.localized]
                    $0.onChange(updateForm)
                }
            return positionSection
        case .fullName:
            let key = SectionTag.fullName.rawValue
            let fullNameSection = FullNameSection(NSLocalizedString(key, comment: "")) {
                $0.tag = key
            }
            fullNameSection.setupRows()
            return fullNameSection
        case .salary:
            let key = SectionTag.salary.rawValue
            let salarySection = Section {
                $0.tag = key
            }
            salarySection
                <<< IntRow {
                    let text = NSLocalizedString(key, comment: "")
                    $0.title = text.capitalizingFirstLetter()
                    $0.placeholder = text
                }
            return salarySection
        case .consultingHours:
            let key = SectionTag.consultingHours.rawValue
            let consultingHoursSection = TimeSection(NSLocalizedString(key, comment: "")) {
                $0.tag = key
            }
            consultingHoursSection.setupRows()
            return consultingHoursSection
        case .workplace:
            let key = SectionTag.workplace.rawValue
            let workplaceSection = Section {
                $0.tag = key
            }
            workplaceSection
                <<< IntRow {
                    let text = NSLocalizedString(key, comment: "")
                    $0.title = text.capitalizingFirstLetter()
                    $0.placeholder = text
                }
            return workplaceSection
        case .lunchTime:
            let key = SectionTag.lunchTime.rawValue
            let lunchTimeSection = TimeSection(NSLocalizedString(key, comment: "")) {
                $0.tag = key
            }
            lunchTimeSection.setupRows()
            return lunchTimeSection
        case .accountingDepartment:
            var options: [String] = []
            let service = AccountantService()
            service.context = coreDataStack.managedContext
            if let types = service.fetchTypes() {
                options = types.compactMap { $0.localized }
            }

            let key = SectionTag.accountingDepartment.rawValue
            let accountingDepartmentSection = Section(NSLocalizedString(key, comment: "")) {
                $0.tag = key
            }
            accountingDepartmentSection <<<
                PickerInputRow<String>() {
                    $0.title = NSLocalizedString("type", comment: "").capitalizingFirstLetter()
                    $0.options = options
                    $0.value = $0.options.first
                }
            return accountingDepartmentSection
        }
    }
}
