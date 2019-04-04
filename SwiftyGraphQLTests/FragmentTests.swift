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
        let fragment = Frag2.self.fragmentStatement
        XCTAssertEqual(fragment, "fragment frag2 on Frag2 { address birthday }")
    }
    
    func testWithoutDefaultValues() {
        struct Test: GraphQLFragmentRepresentable {
            let yes: String
            let no: String
            
            static var attributes: [String] {
                return ["yes", "no"]
            }
            
            static var entityName: String {
                return "CoolFragment"
            }
            
            static var fragmentName: String {
                return "myNeatFragment"
            }
        }
        
        let fragment = Test.self.fragmentStatement
        XCTAssertEqual(fragment, "fragment myNeatFragment on CoolFragment { no yes }")
    }
}
