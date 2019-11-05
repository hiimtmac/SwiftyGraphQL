//
//  GraphQLVariableRepresentable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLVariableRepresentable: Encodable, GraphQLObject {
    static var variableType: String { get }
}

extension GraphQLVariableRepresentable {
    public static var variableType: String {
        return entityName
    }
    
    var variableType: String {
        return Self.variableType
    }
}

extension String: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "String"
    }
}

extension Int: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Int"
    }
}

extension Double: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Float"
    }
}

extension Float: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Float"
    }
}

extension Bool: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Boolean"
    }
}
