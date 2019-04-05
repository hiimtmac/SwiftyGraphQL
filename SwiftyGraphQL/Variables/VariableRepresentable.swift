//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLVariableRepresentable: Encodable, GraphQLObject {
    static var variableType: String { get }
}

public protocol GraphQLDefaultVariableRepresentable: GraphQLVariableRepresentable, GraphQLParameterRepresentable {}

extension GraphQLVariableRepresentable {
    public static var variableType: String {
        return entityName
    }
}

extension String: GraphQLDefaultVariableRepresentable {
    public static var variableType: String {
        return "String"
    }
}

extension Int: GraphQLDefaultVariableRepresentable {
    public static var variableType: String {
        return "Integer"
    }
}

extension Double: GraphQLDefaultVariableRepresentable {
    public static var variableType: String {
        return "Float"
    }
}

extension Float: GraphQLDefaultVariableRepresentable {
    public static var variableType: String {
        return "Float"
    }
}

extension Bool: GraphQLDefaultVariableRepresentable {
    public static var variableType: String {
        return "Boolean"
    }
}
