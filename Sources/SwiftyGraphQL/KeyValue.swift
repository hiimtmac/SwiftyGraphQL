// KeyValue.swift
// Copyright © 2022 hiimtmac

import Foundation

struct GQLKeyValue: GraphQLExpression {
    let key: String
    let value: GraphQLExpression

    func serialize(to serializer: inout Serializer) {
        serializer.write(self.key)
        serializer.write(": ")
        self.value.serialize(to: &serializer)
    }
}

extension Dictionary where Key == String, Value: GraphQLExpression {
    var keyValues: [GQLKeyValue] {
        self.map { GQLKeyValue(key: $0.key, value: $0.value) }
    }
}
