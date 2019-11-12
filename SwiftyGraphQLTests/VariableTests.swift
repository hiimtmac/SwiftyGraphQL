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
   
    struct Object: GraphQLVariableRepresentable {
        static let variableType: String = "Object"
        let name: String
    }

    func testVariables() {
        let o: Int? = nil
        XCTAssertEqual(GraphQLVariable(name: "test", value: 7).type, "Int!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: o).type, "Int")
        
        XCTAssertEqual(GraphQLVariable(name: "test", value: true).type, "Boolean!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: nil as Bool?).type, "Boolean")
        
        XCTAssertEqual(GraphQLVariable(name: "test", value: 7.5).type, "Float!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: nil as Double?).type, "Float")
        
        XCTAssertEqual(GraphQLVariable(name: "test", value: "hi").type, "String!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: nil as String?).type, "String")

        XCTAssertEqual(GraphQLVariable(name: "test", value: Object(name: "hi")).type, "Object!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: nil as Object?).type, "Object")
        
        XCTAssertEqual(GraphQLVariable(name: "test", value: [1, 2, 3]).type, "[Int!]!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: nil as [Int]?).type, "[Int!]")
        XCTAssertEqual(GraphQLVariable(name: "test", value: [nil as Int?] as [Int?]).type, "[Int]!")
        XCTAssertEqual(GraphQLVariable(name: "test", value: [nil as Int?] as [Int?]?).type, "[Int]")
    }
    
    func testVariableStatment() {
        let ints = GraphQLVariables([
            GraphQLVariable(name: "int", value: 7),
            GraphQLVariable(name: "intOpt", value: nil as Int?)
            ])
        XCTAssertEqual(ints.statement, #"($int: Int!, $intOpt: Int)"#)
        
        let bools = GraphQLVariables([
            GraphQLVariable(name: "bool", value: true),
            GraphQLVariable(name: "boolOpt", value: nil as Bool?)
            ])
        XCTAssertEqual(bools.statement, #"($bool: Boolean!, $boolOpt: Boolean)"#)
        
        let doubles = GraphQLVariables([
            GraphQLVariable(name: "double", value: 7.5),
            GraphQLVariable(name: "doubleOpt", value: nil as Double?)
            ])
        XCTAssertEqual(doubles.statement, #"($double: Float!, $doubleOpt: Float)"#)
        
        let strings = GraphQLVariables([
            GraphQLVariable(name: "string", value: "hi"),
            GraphQLVariable(name: "stringOpt", value: nil as String?)
            ])
        XCTAssertEqual(strings.statement, #"($string: String!, $stringOpt: String)"#)
        
        let objs = GraphQLVariables([
            GraphQLVariable(name: "obj", value: Object(name: "hi")),
            GraphQLVariable(name: "objOpt", value: nil as Object?)
            ])
        XCTAssertEqual(objs.statement, #"($obj: Object!, $objOpt: Object)"#)
        
        let arrays = GraphQLVariables([
            GraphQLVariable(name: "array", value: [1, 2, 3]),
            GraphQLVariable(name: "arrayOpt", value: nil as [Int]?),
            GraphQLVariable(name: "arrayElementOpt", value: [nil as Int?] as [Int?]),
            GraphQLVariable(name: "arrayOptElementOpt", value: [nil as Int?] as [Int?]?)
        ])
        XCTAssertEqual(arrays.statement, #"($array: [Int!]!, $arrayElementOpt: [Int]!, $arrayOpt: [Int!], $arrayOptElementOpt: [Int])"#)
    }

    
    func testVariableJSONEncoding() throws {
        let variables = GraphQLVariables([
            GraphQLVariable(name: "int", value: 7),
            GraphQLVariable(name: "intOpt", value: nil as Int?),
            GraphQLVariable(name: "bool", value: false),
            GraphQLVariable(name: "array", value: [1,2,3]),
            GraphQLVariable(name: "arrayOpt", value: nil as [Int]?),
            GraphQLVariable(name: "arrayElementOpt", value: [nil as Int?, 2] as [Int?]),
            GraphQLVariable(name: "arrayOptElementOpt", value: nil as [Int?]?)
        ])
        
        struct Decode: Decodable {
            let int: Int
            let intOpt: Int?
            let bool: Bool
            let array: [Int]
            let arrayOpt: [Int]?
            let arrayElementOpt: [Int?]
            let arrayOptElementOpt: [Int?]?
        }
        
        let encoded = try JSONEncoder().encode(variables)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.int, 7)
        XCTAssertEqual(decoded.bool, false)
        XCTAssertEqual(decoded.array, [1,2,3])
        XCTAssertNil(decoded.arrayOpt)
        XCTAssertEqual(decoded.arrayElementOpt, [nil, 2])
        XCTAssertNil(decoded.arrayOptElementOpt)
        XCTAssertEqual(variables.statement, #"($array: [Int!]!, $arrayElementOpt: [Int]!, $arrayOpt: [Int!], $arrayOptElementOpt: [Int], $bool: Boolean!, $int: Int!, $intOpt: Int)"#)
    }
}
