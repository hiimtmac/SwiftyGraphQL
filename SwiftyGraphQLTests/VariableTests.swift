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
    /*
    var int: GraphQLVariable!
    var optInt: GraphQLVariable!
    var optIntDef: GraphQLVariable!
    
    var string: GraphQLVariable!
    var optString: GraphQLVariable!
    var optStringDef: GraphQLVariable!
    
    var obj: GraphQLVariable!
    var optObj: GraphQLVariable!
    var optObjDef: GraphQLVariable!

    struct Object: GraphQLVariableRepresentable {
        let name: String
    }
    
    override func setUp() {
        super.setUp()
        
        let intVal: Int = 7
        int = GraphQLVariable(key: "int", value: intVal, type: Int.self)
        
        let stringVal: String = "hi"
        string = GraphQLVariable(key: "string", value: stringVal, type: String.self)
        
        let objVal: Object = Object(name: "hiimtmac")
        obj = GraphQLVariable(key: "obj", value: objVal, type: Object.self)
        
        let optIntVal: Int? = 7
        optInt = GraphQLVariable(key: "intOpt", value: optIntVal, type: Int.self)
        
        let optStringVal: String? = "hi"
        optString = GraphQLVariable(key: "stringOpt", value: optStringVal, type: String.self)
        
        let optObjVal: Object? = Object(name: "hiimtmac")
        optObj = GraphQLVariable(key: "objOpt", value: optObjVal, type: Object.self)
        
        let optIntDefVal: Int? = nil
        optIntDef = GraphQLVariable(key: "intOptDef", value: optIntDefVal, type: Int.self, default: 3)
        
        let optStringDefVal: String? = nil
        optStringDef = GraphQLVariable(key: "stringOptDef", value: optStringDefVal, type: String.self, default: "eh")
        
        let optObjDefVal: Object? = nil
        optObjDef = GraphQLVariable(key: "objOptDef", value: optObjDefVal, type: Object.self, default: Object(name: "taylor"))
    }

    func testVariables() {
        XCTAssertEqual(int.variableParameter, "Int!")
        XCTAssertEqual(optInt.variableParameter, "Int")
        XCTAssertEqual(optIntDef.variableParameter, "Int = 3")
        
        XCTAssertEqual(string.variableParameter, "String!")
        XCTAssertEqual(optString.variableParameter, "String")
        XCTAssertEqual(optStringDef.variableParameter, #"String = "eh""#)
        
        XCTAssertEqual(obj.variableParameter, "Object!")
        XCTAssertEqual(optObj.variableParameter, "Object")
        XCTAssertEqual(optObjDef.variableParameter, #"Object = "eh""#)
    }
    
    func testVariablesEncodingArray() {
        let variables = GraphQLVariables([int, optInt, optIntDef, string, optString, optStringDef])
        let compare = #"($int: Int!, $intOpt: Int, $intOptDef: Int = 3, $string: String!, $stringOpt: String, $stringOptDef: String = "eh")"#
        XCTAssertEqual(variables.statement, compare)
    }
    
    func testVariablesEncodingDict() {
        let variables = GraphQLVariables(["int": int, "intOpt": optInt, "intOptDef": optIntDef, "string": string, "stringOpt": optString, "stringOptDef": optStringDef])
        let compare = #"($int: Int!, $intOpt: Int, $intOptDef: Int = 3, $string: String!, $stringOpt: String, $stringOptDef: String = "eh")"#
        XCTAssertEqual(variables.statement, compare)
    }
    
    func testVariableEncoding() throws {
        let variables = GraphQLVariables([int, optStringDef])
        
        let encode = try JSONEncoder().encode(variables)
        print(String(data: encode, encoding: .utf8)!)
        
    }
 */
    
    struct Test: GraphQLObject, GraphQLVariableRepresentable {
        
    }
    
    func testMe() {
        let variableType = Test.self.variableType
        XCTAssertEqual(variableType, "Test")
    }
}
