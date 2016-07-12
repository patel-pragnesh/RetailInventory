//
//  DepartmentMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum DepartmentField: String {
    case active = "active",
    icon = "icon",
    id = "id",
    itemsEbt = "itemsEbt",
    name = "name"
}

class DepartmentData: EntityMethods<Department> {
    
    init() {
        let departments = DataManager.fetchAllDepartment()
        super.init(array: departments)
    }
    
    func getIndexById(id: Int) -> Int {
        var i: Int = 0
        for department in array {
            if department.id == id {
                return i
            }
            i += 1
        }
        return -1
    }
    
    func updateDepartments(serverDepartments: [DepartmentResponse]) {
        var editing_index = [Int]()
        var add_index = [Int]()
        for i in 0 ... serverDepartments.count - 1 {
            var isConsist = false
            if array.count != 0 {
                for j in 0 ... array.count - 1 {
                    if array[j].id == serverDepartments[i].id {
                        editDepartmentWithResponse(array[j], departmentResponse: serverDepartments[i])
                        editing_index.append(j)
                        isConsist = true
                        break
                    }
                }
            }

            if !isConsist { add_index.append(i) }
        }
        
        if array.count != 0 {
            for i in 0 ... array.count - 1 {
                if (editing_index.indexOf(i) == nil) {
                    removeDepartment(array[i])
                }
            }
        }

        if add_index.count > 0 {
            for i in 0 ... serverDepartments.count - 1 {
                if (add_index.indexOf(i) != nil) {
                    let newDep = DepartmentData.addDepartment(serverDepartments[i].name, id: serverDepartments[i].id, icon: nil, active: serverDepartments[i].active, itemsEbt: serverDepartments[i].ebtItem)
                    TaxData.updateTaxesWithDepartmentResponse(newDep, taxesId: serverDepartments[i].taxesId)
                }
            }
        }
//        for serverDepartment in serverDepartments {
//            let index = getIndexById(serverDepartment.id)
//            switch index {
//            case -1:
//                addDepartment(serverDepartment.name, id: serverDepartment.id, icon: nil, active: serverDepartment.active, itemsEbt: serverDepartment.itemsAreEBT)
//            default:
//                editDepartmentWithResponse(array[index], departmentResponse: serverDepartment)
//            }
//        }
//        for localDepartment in array {
//            var isConsist = false
//            for responseDepartment in serverDepartments {
//                if localDepartment.id == responseDepartment.id {
//                    isConsist = true
//                }
//            }
//            if !isConsist {
//                removeDepartment(localDepartment)
//            }
//        }        
//        DataManager.saveContext()
    }
    
//    func addDepartment(name: String?, id: NSNumber?, icon: String?, active: NSNumber?, itemsEbt: NSNumber?) -> Department {
//        return DataManager.addDepartment(name, id: id, icon: icon, active: active, itemsEbt: itemsEbt)
//    }
    
    static func addDepartment(name: String?, id: Int?, icon: String?, active: Bool?, itemsEbt: Bool?) -> Department {
        return DataManager.addDepartment(name, id: id, icon: icon, active: active, itemsEbt: itemsEbt)
    }
    
    func addDepartmentFromTemplate(template: DepartmentTemplate) {
        DataManager.addDepartment(template.name, id: template.id, icon: template.icon, active: template.active, itemsEbt: template.itemsEbt)
    }
    
    func editDepartmentWithTemplate(index: Int, template: DepartmentTemplate) {
        array[index].name = template.name
        array[index].icon = template.icon
        array[index].active = template.active
        array[index].itemsEbt = template.itemsEbt
        array[index].id = template.id
        
        DataManager.saveContext()
    }
    
    func editDepartmentWithResponse(department: Department, departmentResponse: DepartmentResponse) {
        department.name = departmentResponse.name
        department.active = departmentResponse.active
        department.itemsEbt = departmentResponse.ebtItem
        let i = UInt32(strtoul(departmentResponse.glyph, nil, 16)) // to decimal
        department.icon = String(Character(UnicodeScalar(i)))      // to char and string
        
        TaxData.updateTaxesWithDepartmentResponse(department, taxesId: departmentResponse.taxesId)
    }
    
    func editDepartment(index: Int, newDepartment: Department) {
        array[index] = newDepartment
        DataManager.saveContext()
    }
    
    static func editDepartment(field: DepartmentField, department: Department, value: AnyObject?) {
        department[field.rawValue] = value
        self.save()
    }
    
    func removeDepartment(department: Department) -> Bool {
        return DataManager.deleteDepartment(department)
    }
    
    override func refresh() {
        array = DataManager.fetchAllDepartment()
    }
    
    static func getCountFromDB() -> UInt {
        return DataManager.getCountDepartment()
    }
    
    static func departmentBy( id: NSNumber) -> Department {
        return DataManager.getFirstDepartmentByAttribute("id", value: id)
    }
    
    static func fieldDetail(fieldName: DepartmentField, department: DepartmentTemplate) -> AnyObject? {
        return department[fieldName.rawValue]! as AnyObject
    }
    
    static func addDepartmentFromResponse(responseDepartment: [String: AnyObject]) {
        let name = responseDepartment["name"] as? String
        let id = responseDepartment["id"] as? Int
        let icon = responseDepartment["icon"] as? String
        let itemEbt = responseDepartment["itemsEbt"] as? Bool
        let active = responseDepartment["active"] as? Bool
        addDepartment(name, id: id, icon: icon, active: active, itemsEbt: itemEbt)
    }
    
    static func updateDepartmentFromResponse(responseDepartment: [String: AnyObject]) {
        let id = responseDepartment["id"] as? Int
        
        let department = departmentBy(id!)
        
        department.name = responseDepartment["name"] as? String
        department.active = responseDepartment["active"] as? Bool
        department.itemsEbt = responseDepartment["itemsEbt"] as? Bool
        department.icon = responseDepartment["icon"] as? String

    }
}