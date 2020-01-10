//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-01-08.
//

import XCTest
@testable import SwiftyGraphQL

class AttributeTests: XCTestCase {

    func testStrings() {
        let attributes = GQLAttributes {
            "hello"
            "there"
        }
        
        XCTAssertEqual(attributes.gqlQueryString, "hello there")
    }
    
    func testCodedKey() {
        struct Cool: GQLAttributable {
            enum CodingKeys: String, CodingKey {
                case hello
                case there
            }
        }
        
        let attributes = GQLAttributes(Cool.self) { t in
            t.hello
            t.there
        }
        
        XCTAssertEqual(attributes.gqlQueryString, "hello there")
    }
    
    func testFullFrgment() {
        struct Cool: GQLAttributable {
            enum CodingKeys: String, CodingKey, CaseIterable {
                case hello
                case there
            }
        }
        
        let attributes = GQLAttributes(Cool.self)
        
        XCTAssertEqual(attributes.gqlQueryString, "hello there")
    }
    
    func testDefaultImplementation() {
        struct Object: GQLFragmentable, GQLAttributable {
            enum CodingKeys: String, CodingKey, CaseIterable {
                case one
                case two
                case three = "four"
            }
        }
        
        let fragment = GQLFragment(Object.self)
        XCTAssertEqual(fragment.gqlQueryString, "...object")
        XCTAssertEqual(fragment.gqlFragmentString, "fragment object on Object { four one two }")
    }
    
    static var allTests = [
        ("testStrings", testStrings),
        ("testCodedKey", testCodedKey),
        ("testFullFrgment", testFullFrgment),
        ("testDefaultImplementation", testDefaultImplementation)
    ]
}
