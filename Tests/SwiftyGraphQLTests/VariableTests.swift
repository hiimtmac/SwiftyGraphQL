//
//  VariableTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class VariableTests: XCTestCase {
   
    struct CustomStruct: GQLVariable {
        static var gqlBaseType: String { "CustomStructure" }
    }
    
    class CustomClass: GQLVariable {}
    
    struct CustomGenericStruct<T>: GQLVariable {
        static var gqlBaseType: String { "CustomStringStructure" }
    }
    
    class CustomGenericClass<T>: GQLVariable {
        static var gqlBaseType: String { "CustomStringClass" }
    }
    
    func testStandard() {
        XCTAssertEqual(type(of: "string").gqlVariableType, "String!")
        XCTAssertEqual(type(of: "string" as String?).gqlVariableType, "String")
        XCTAssertEqual(type(of: 5).gqlVariableType, "Int!")
        XCTAssertEqual(type(of: 5 as Int?).gqlVariableType, "Int")
        XCTAssertEqual(type(of: 5 as Float).gqlVariableType, "Float!")
        XCTAssertEqual(type(of: 5 as Float?).gqlVariableType, "Float")
        XCTAssertEqual(type(of: 5 as Double).gqlVariableType, "Float!")
        XCTAssertEqual(type(of: 5 as Double?).gqlVariableType, "Float")
        XCTAssertEqual(type(of: true).gqlVariableType, "Boolean!")
        XCTAssertEqual(type(of: true as Bool?).gqlVariableType, "Boolean")
    }
    
    func testCustom() {
        XCTAssertEqual(type(of: CustomStruct()).gqlVariableType, "CustomStructure!")
        XCTAssertEqual(type(of: CustomStruct() as CustomStruct?).gqlVariableType, "CustomStructure")
        XCTAssertEqual(type(of: CustomClass()).gqlVariableType, "CustomClass!")
        XCTAssertEqual(type(of: CustomClass() as CustomClass?).gqlVariableType, "CustomClass")
        XCTAssertEqual(type(of: CustomGenericStruct<String>()).gqlVariableType, "CustomStringStructure!")
        XCTAssertEqual(type(of: CustomGenericStruct<String>() as CustomGenericStruct<String>?).gqlVariableType, "CustomStringStructure")
        XCTAssertEqual(type(of: CustomGenericClass<String>()).gqlVariableType, "CustomStringClass!")
        XCTAssertEqual(type(of: CustomGenericClass<String>() as CustomGenericClass<String>?).gqlVariableType, "CustomStringClass")
    }
}
