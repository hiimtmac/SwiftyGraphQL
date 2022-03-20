// FragmentTests.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import SwiftyGraphQL

class FragmentTests: BaseTestCase {
    let f1 = GQLFragment(Frag1.self)
    let f2 = GQLFragment(Frag2.self)
    let f3 = GQLFragment(Frag3.self)
    let f4 = GQLFragment(name: "cool", type: "Beans") {
        "just"
        "do"
        "it"
    }

    func testWithRawKeys() {
        self.f1.fragmentBody.serialize(to: &serializer)
        XCTAssertEqual(serializer.graphQL, "fragment frag1 on Frag1 { name age }")
    }

    func testWithDefault() {
        self.f2.fragmentBody.serialize(to: &serializer)
        XCTAssertEqual(serializer.graphQL, "fragment frag2 on Frag2 { birthday address }")
    }

    func testWithCodingKeys() {
        self.f3.fragmentBody.serialize(to: &serializer)
        XCTAssertEqual(serializer.graphQL, "fragment fragment3 on Fragment3 { name age address cool }")
    }

    func testWithUntyped() {
        self.f4.fragmentBody.serialize(to: &serializer)
        XCTAssertEqual(serializer.graphQL, "fragment cool on Beans { just do it }")
    }

    func testSerializer() {
        serializer.write(fragment: self.f1)
        serializer.write(fragment: self.f2)
        serializer.write(fragment: self.f3)
        serializer.write(fragment: self.f4)

        let f = GQLFragment(name: "cool", type: "Beans") {
            "replace"
        }

        serializer.write(fragment: f)
        XCTAssertEqual(serializer.fragments.count, 4)
    }

    static var allTests = [
        ("testWithRawKeys", testWithRawKeys),
        ("testWithDefault", testWithDefault),
        ("testWithCodingKeys", testWithCodingKeys),
        ("testWithUntyped", testWithUntyped),
        ("testSerializer", testSerializer),
    ]
}
