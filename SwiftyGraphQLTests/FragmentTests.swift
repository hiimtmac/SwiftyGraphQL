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
        let fragment = Frag2.self.fragment
        XCTAssertEqual(fragment, "fragment frag2 on Frag2 { birthday address }")
    }
    
    func testWithoutDefaultValues() {        
        let fragment = Frag1.self.fragment
        XCTAssertEqual(fragment, "fragment fragment1 on Fragment1 { name age }")
    }
}
