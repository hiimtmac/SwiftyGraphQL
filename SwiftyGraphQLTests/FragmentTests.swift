//
//  FragmentTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class FragmentTests: XCTestCase {

    func testWithDefaultValues() {
        XCTAssertEqual(Frag2.self.fragmentString, "fragment frag2 on Frag2 { address birthday }")
    }
    
    func testWithoutDefaultValues() {
        struct Test: GQLFragmentable {
            let yes: String
            let no: String
            
            static var gqlContent: GraphQL {
                GQLAttributes {
                    "no"
                    "yes"
                }
            }
            
            static var fragmentType: String { return "CoolFragment" }
            static var fragmentName: String { return "myNeatFragment" }
        }
        
        XCTAssertEqual(Test.self.fragmentString, "fragment myNeatFragment on CoolFragment { no yes }")
    }
}
