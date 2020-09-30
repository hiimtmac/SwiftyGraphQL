//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import XCTest
@testable import SwiftyGraphQL

class BaseTestCase: XCTestCase {
    var serializer = Serializer()
    
    var graphQL: String { serializer.graphQL }
    var variables: [String: GQLVariable] { serializer.variables }
    var fragments: [String: GQLFragment] { serializer.fragments }
    
    var fragmentQL: String {
        let values = fragments.map(\.value.fragmentBody).sorted()
        let list = GQLList(values, delimiter: " ")
        var serial = Serializer()
        list.serialize(to: &serial)
        return serial.graphQL
    }
}
