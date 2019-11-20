//
//  User.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User {
    let id: Int? = nil
    
    let username: String
    let password: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let streetAddress: String
    let state: String
    let zipCode: String
    let orgId: Int = 1
    
    var isAdmin: Bool
    var isOrganization: Bool
    
    var employeeRepresentation: EmployeeRepresentation? {
        if isOrganization { return nil } else {
            return EmployeeRepresentation(
                username: username,
                password: password,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                streetAddress: streetAddress,
                state: state,
                zipcode: zipCode,
                orgId: orgId,
                contactPerson: "",
                role: isAdmin ? "orgAdmin" : "employee")
        }
    }
    
    var orgRepresentation: OrganizationRepresentation? {
        if isOrganization { return OrganizationRepresentation(
            username: username,
            password: password,
            organizationName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            streetAddress: streetAddress,
            state: state,
            zipcode: zipCode,
            contactPerson: "")
        } else { return nil }
    }
    
    struct EmployeeRepresentation: Codable {
        let username: String
        let password: String
        let fullName: String
        let email: String
        let phoneNumber: String
        let streetAddress: String
        let state: String
        let zipcode: String
        let orgId: Int
        let contactPerson: String
        let role: String
    }
    
    struct OrganizationRepresentation: Codable {
        let username: String
        let password: String
        let organizationName: String
        let email: String
        let phoneNumber: String
        let streetAddress: String
        let state: String
        let zipcode: String
        let contactPerson: String
    }
}
