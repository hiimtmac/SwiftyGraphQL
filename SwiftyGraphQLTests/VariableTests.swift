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
    var intOpt: GraphQLVariable!
    var intOptDef: GraphQLVariable!
    
    var bool: GraphQLVariable!
    var boolOpt: GraphQLVariable!
    var boolOptDef: GraphQLVariable!
    
    var float: GraphQLVariable!
    var floatOpt: GraphQLVariable!
    var floatOptDef: GraphQLVariable!
    
    var double: GraphQLVariable!
    var doubleOpt: GraphQLVariable!
    var doubleOptDef: GraphQLVariable!
    
    var string: GraphQLVariable!
    var stringOpt: GraphQLVariable!
    var stringOptDef: GraphQLVariable!
    
    var obj: GraphQLVariable!
    var objOpt: GraphQLVariable!
    
    var objC: GraphQLVariable!
    var objCOpt: GraphQLVariable!

    struct ObjectDefault: GraphQLVariableRepresentable {
        let name: String
    }
    
    struct ObjectCustom: GraphQLVariableRepresentable {
        let name: String
        
        static var entityName: String {
            return "MyCoolObject"
        }
    }
    
    override func setUp() {
        super.setUp()
        
        int = GraphQLVariable(value: 7)
        let intValOpt: Int? = 7
        intOpt = GraphQLVariable(value: intValOpt)
        intOptDef = GraphQLVariable(value: nil, defaultValue: 7)
        
        bool = GraphQLVariable(value: true)
        let boolValOpt: Bool? = false
        boolOpt = GraphQLVariable(value: boolValOpt)
        boolOptDef = GraphQLVariable(value: nil, defaultValue: true)
        
        let floatVal: Float = 7
        float = GraphQLVariable(value: floatVal)
        let floatValOpt: Float? = 7.3
        floatOpt = GraphQLVariable(value: floatValOpt)
        let floatValDef: Float? = nil
        floatOptDef = GraphQLVariable(value: floatValDef, defaultValue: 3.6)
        
        double = GraphQLVariable(value: 8.1)
        let doubleValOpt: Double? = 7.6
        doubleOpt = GraphQLVariable(value: doubleValOpt)
        doubleOptDef = GraphQLVariable(value: nil, defaultValue: 2.5)
        
        string = GraphQLVariable(value: "hi")
        let stringValOpt: String? = "hi"
        stringOpt = GraphQLVariable(value: stringValOpt)
        stringOptDef = GraphQLVariable(value: nil, defaultValue: "hello")
        
        obj = GraphQLVariable(value: ObjectDefault(name: "hiimtmac"))
        let objValOpt: ObjectDefault? = ObjectDefault(name: "hiimtmac")
        objOpt = GraphQLVariable(value: objValOpt)
        
        objC = GraphQLVariable(value: ObjectCustom(name: "hiimtmac"))
        let objCValOpt: ObjectCustom? = ObjectCustom(name: "hiimtmac")
        objCOpt = GraphQLVariable(value: objCValOpt)
    }

    func testVariables() {
        XCTAssertEqual(int.type, "Integer!")
        XCTAssertEqual(intOpt.type, "Integer")
        XCTAssertEqual(intOptDef.type, "Integer = 7")
        
        XCTAssertEqual(bool.type, "Boolean!")
        XCTAssertEqual(boolOpt.type, "Boolean")
        XCTAssertEqual(boolOptDef.type, "Boolean = true")
        
        XCTAssertEqual(float.type, "Float!")
        XCTAssertEqual(floatOpt.type, "Float")
        XCTAssertEqual(floatOptDef.type, "Float = 3.6")
        
        XCTAssertEqual(double.type, "Float!")
        XCTAssertEqual(doubleOpt.type, "Float")
        XCTAssertEqual(doubleOptDef.type, "Float = 2.5")
        
        XCTAssertEqual(string.type, "String!")
        XCTAssertEqual(stringOpt.type, "String")
        XCTAssertEqual(stringOptDef.type, #"String = "hello""#)
        
        XCTAssertEqual(obj.type, "ObjectDefault!")
        XCTAssertEqual(objOpt.type, "ObjectDefault")
        
        XCTAssertEqual(objC.type, "MyCoolObject!")
        XCTAssertEqual(objCOpt.type, "MyCoolObject")
    }
    
    func testVariableStatment() {
        let ints = GraphQLVariables([
            "int": int,
            "intOpt": intOpt,
            "intOptDef": intOptDef
            ])
        XCTAssertEqual(ints.statement, #"($int: Integer!, $intOpt: Integer, $intOptDef: Integer = 7)"#)
        
        let bools = GraphQLVariables([
            "bool": bool,
            "boolOpt": boolOpt,
            "boolOptDef": boolOptDef
            ])
        XCTAssertEqual(bools.statement, #"($bool: Boolean!, $boolOpt: Boolean, $boolOptDef: Boolean = true)"#)
        
        let floats = GraphQLVariables([
            "float": float,
            "floatOpt": floatOpt,
            "floatOptDef": floatOptDef
            ])
        XCTAssertEqual(floats.statement, #"($float: Float!, $floatOpt: Float, $floatOptDef: Float = 3.6)"#)
        
        let doubles = GraphQLVariables([
            "double": double,
            "doubleOpt": doubleOpt,
            "doubleOptDef": doubleOptDef
            ])
        XCTAssertEqual(doubles.statement, #"($double: Float!, $doubleOpt: Float, $doubleOptDef: Float = 2.5)"#)
        
        let strings = GraphQLVariables([
            "string": string,
            "stringOpt": stringOpt,
            "stringOptDef": stringOptDef
            ])
        XCTAssertEqual(strings.statement, #"($string: String!, $stringOpt: String, $stringOptDef: String = "hello")"#)
        
        let objs = GraphQLVariables([
            "obj": obj,
            "objOpt": objOpt
            ])
        XCTAssertEqual(objs.statement, #"($obj: ObjectDefault!, $objOpt: ObjectDefault)"#)

        let objCs = GraphQLVariables([
            "objC": objC,
            "objCOpt": objCOpt
            ])
        XCTAssertEqual(objCs.statement, #"($objC: MyCoolObject!, $objCOpt: MyCoolObject)"#)
    }

    func testMixedVariableStatement() {
        let variables = GraphQLVariables([
            "int": int,
            "boolOpt": boolOpt,
            "floatOptDef": floatOptDef,
            "double": double,
            "stringOptDef": stringOptDef,
            "objOpt": objOpt,
            "objC": objC
            ])
        XCTAssertEqual(variables.statement, #"($boolOpt: Boolean, $double: Float!, $floatOptDef: Float = 3.6, $int: Integer!, $objC: MyCoolObject!, $objOpt: ObjectDefault, $stringOptDef: String = "hello")"#)
    }
    */
    
    func testVariableJSONEncoding() throws {
        let variables = GraphQLVariables([
            GraphQLVariable(name: "int", value: 7),
            GraphQLVariable(name: "bool", value: false)
        ])
        
        struct Decode: Decodable {
            let int: Int
            let bool: Bool
        }
        
        let encoded = try JSONEncoder().encode(variables)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.int, 7)
        XCTAssertEqual(decoded.bool, false)
    }
}
