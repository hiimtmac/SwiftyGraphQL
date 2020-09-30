//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import Foundation

struct GQLKeyValue: GraphQLExpression {
    let key: String
    let value: GraphQLExpression
    
    func serialize(to serializer: inout Serializer) {
        serializer.write(key)
        serializer.write(": ")
        value.serialize(to: &serializer)
    }
}

extension Dictionary where Key == String, Value: GraphQLExpression {
    var keyValues: [GQLKeyValue] {
        self.map { GQLKeyValue(key: $0.key, value: $0.value) }
    }
}
