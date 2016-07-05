//
//  DepartmentMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class DepartmentData: EntityMethods<Department> {
    
    init() {
        let inventorys = Department.MR_findAllSortedBy("name", ascending: true) as! [Department]
        super.init(array: inventorys)
    }
    
    func addObject() -> Department {
        let newDepartment = Department.MR_createEntity()!
        array.append(newDepartment)
        return newDepartment
    }
    
    func removeObject(department: Department) {
        department.MR_deleteEntity()
    }
    
    func editObject(old: Department, new: Department) -> Bool {
        let index = array.indexOf(old)
        if index != nil {
            array[index!] = new
            return true
        } else {
            return false
        }
    }
}