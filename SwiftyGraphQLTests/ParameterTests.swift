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
        let parameters = Parameters(["since": 20, "name": "taylor"])
        
        let compare = """
        (name: "taylor", since: 20)
        """
        XCTAssertEqual(parameters.description, compare)
    }
    
    func testParametersWithOptionals() {
        let num: Int? = nil
        let string: String? = nil
        let parameters = Parameters(["since": num ?? "NULL", "name": string ?? "NULL", "other": 2, "date": "today"])
        
        let compare = """
        (date: "today", name: "NULL", other: 2, since: "NULL")
        """
        XCTAssertEqual(parameters.description, compare)
    }
    
    func testParametersEmpty() {
        let parameters = Parameters([:])
        
        let compare = ""
        XCTAssertEqual(parameters.description, compare)
    }
    
    func testQuoteEscaped() {
        let val = """
        thing"thing
        """.graphEncoded()
        
        let compare = """
        "thing\\"thing"
        """
        XCTAssertEqual(val, compare)
    }
    
    func testSlashEscaped() {
        let val = """
        thing\\thing
        """.graphEncoded()
        
        let compare = """
        "thing\\\\thing"
        """
        XCTAssertEqual(val, compare)
    }
    
    func testSlashQuoteEscaped() {
        let val = """
        thing\\"thing
        """.graphEncoded()
        
        let compare = """
        "thing\\\\\\"thing"
        """
        XCTAssertEqual(val, compare)
    }
    
    func testParametersEncoded() {
        let val1 = """
        thing"thing
        """
        
        let val2 = """
        thing\\thing
        """
        
        let val3 = """
        thing\\"thing
        """
        
        let parameters = Parameters(["since":val1, "ok":val2, "yes": val3, "sure": 4, "normal":"also"])
        
        let compare = """
        (normal: "also", ok: "thing\\\\thing", since: "thing\\"thing", sure: 4, yes: "thing\\\\\\"thing")
        """
        
        print(compare)
        XCTAssertEqual(parameters.description, compare)
    }
}
