// BaseTestCase.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import SwiftyGraphQL

class BaseTestCase: XCTestCase {
    var serializer = Serializer()

    var graphQL: String { self.serializer.graphQL }
    var variables: [String: GQLVariable] { self.serializer.variables }
    var fragments: [String: GQLFragment] { self.serializer.fragments }

    var fragmentQL: String {
        let values = self.fragments.map(\.value.fragmentBody).sorted()
        let list = GQLList(values, delimiter: " ")
        var serial = Serializer()
        list.serialize(to: &serial)
        return serial.graphQL
    }
}
