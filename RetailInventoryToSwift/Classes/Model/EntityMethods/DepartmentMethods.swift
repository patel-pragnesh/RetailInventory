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

class DepartmentMethods: EntityMethods<Department> {
    
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
                    addDepartment(serverDepartments[i].name, id: serverDepartments[i].id, icon: nil, active: serverDepartments[i].active, itemsEbt: serverDepartments[i].itemsAreEBT)
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
    
    func addDepartment(name: String?, id: NSNumber?, icon: String?, active: NSNumber?, itemsEbt: NSNumber?) -> Department {
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
        department.itemsEbt = departmentResponse.itemsAreEBT
        let i = UInt32(strtoul(departmentResponse.glyph, nil, 16)) // to decimal
        department.icon = String(Character(UnicodeScalar(i)))      // to char and string
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
    
    static func fieldDetail(fieldName: DepartmentField, department: DepartmentTemplate) -> AnyObject? {
        return department[fieldName.rawValue]! as AnyObject
    }
}