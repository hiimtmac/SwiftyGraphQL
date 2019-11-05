//
//  ParameterTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class ParameterTests: XCTestCase {

    func testParameters() {
        let parameters = GraphQLArguments(["since": 20, "name": "taylor", "true": true])
        let compare = #"(name: "taylor", since: 20, true: true)"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testParameterCombination() {
        let nill: String? = nil
        let p1 = GraphQLArguments(["since": 20, "name": "taylor", "nill": nill])
        let p2 = GraphQLArguments(["ok": true, "address": "difficult"])
        let parameters = p1 + p2
        
        let compare = #"(address: "difficult", name: "taylor", nill: null, ok: true, since: 20)"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testParameterCombinationChoosesRhsKeys() {
        let p1 = GraphQLArguments(["since": 20, "name": "taylor", "true": true])
        let p2 = GraphQLArguments(["since": 30, "true": false])
        let parameters = p1 + p2
        
        let compare = #"(name: "taylor", since: 30, true: false)"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testNullParameters() {
        let parameters = GraphQLArguments(["since": nil, "name": "taylor"])
        
        let compare = #"(name: "taylor", since: null)"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testParametersWithOptionals() {
        let num: Int? = nil
        let string: String? = nil
        let parameters = GraphQLArguments(["since": num, "name": string ?? "NULL", "other": 2, "date": "today", "zzz": nil])
        
        let compare = #"(date: "today", name: "NULL", other: 2, since: null, zzz: null)"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testParametersEmpty() {
        let parameters = GraphQLArguments([:])
        let compare = ""
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testQuoteEscaped() {
        let val = #"thing"thing"#.parameterValue
        let compare = #""thing\"thing""#
        XCTAssertEqual(val, compare)
    }
    
    func testSlashEscaped() {
        let val = #"thing\thing"#.parameterValue
        let compare = #""thing\\thing""#
        XCTAssertEqual(val, compare)
    }
    
    func testSlashQuoteEscaped() {
        let val = #"thing\"thing"#.parameterValue
        let compare = #""thing\\\"thing""#
        XCTAssertEqual(val, compare)
    }
    
    func testParametersEncoded() {
        let val1 = #"thing"thing"#
        let val2 = #"thing\thing"#
        let val3 = #"thing\"thing"#
        
        let parameters = GraphQLArguments(["since":val1, "ok":val2, "yes": val3, "sure": 4, "normal":"also"])
        let compare = #"(normal: "also", ok: "thing\\thing", since: "thing\"thing", sure: 4, yes: "thing\\\"thing")"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testNestedParameters() {
        let p1 = GraphQLArguments(["ok": "yes"])
        let p2 = GraphQLArguments(["yes": p1])
        
        let compare = #"(yes: { ok: "yes" })"#
        XCTAssertEqual(p2.statement, compare)
    }
    
    func testArrayParameters() {
        let p1 = GraphQLArguments(["ok": "yes"])
        let p2 = GraphQLArguments(["ok": "no"])
        let p3 = GraphQLArguments(["ok": "maybe"])
        let p4 = GraphQLArguments(["ok": [p1, p2, p3]])
        
        let compare = #"(ok: [ { ok: "maybe" }, { ok: "no" }, { ok: "yes" } ])"#
        XCTAssertEqual(p4.statement, compare)
    }
    
    func testDictionaryParameters() {
        let p1 = GraphQLArguments(["ok": "yes"])
        let p2 = GraphQLArguments(["ok": "no"])
        let p3 = GraphQLArguments(["ok": "maybe"])
        let p4 = GraphQLArguments(["ok": ["p1": p1, "p2": p2, "p3": p3]])
        
        let compare = #"(ok: { "p1": { ok: "yes" }, "p2": { ok: "no" }, "p3": { ok: "maybe" } })"#
        XCTAssertEqual(p4.statement, compare)
    }
    
    func testSingleAppend() {
        var parameters = GraphQLArguments(["since": 20, "name": "taylor"])
        parameters.add(key: "age", value: 12.5)
        
        let compare = #"(age: 12.5, name: "taylor", since: 20)"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testSingleOverride() {
        var parameters = GraphQLArguments(["since": 20, "name": "taylor"])
        parameters.add(key: "since", value: "ok")
        
        let compare = #"(name: "taylor", since: "ok")"#
        XCTAssertEqual(parameters.statement, compare)
    }
    
    func testSubcriptGet() {
        let parameters = GraphQLArguments(["since": 20, "name": "taylor"])
        let name = parameters["name"]
        
        XCTAssertEqual(name.parameterValue, #""taylor""#)
    }
    
    func testSubcriptSet() {
        var parameters = GraphQLArguments(["since": 20, "name": "taylor"])
        parameters["age"] = 12.5
        
        let compare = #"(age: 12.5, name: "taylor", since: 20)"#
        XCTAssertEqual(parameters.statement, compare)
    }
}
