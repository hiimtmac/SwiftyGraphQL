//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-08.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GQLVariable: Encodable {
    static var gqlBaseType: String { get }
    static var gqlVariableType: String { get }
}

extension GQLVariable {
    public static var gqlBaseType: String {
        return "\(Self.self)"
    }
    
    public static var gqlVariableType: String {
        return "\(gqlBaseType)!"
    }
}

extension String: GQLVariable {
    public static var gqlBaseType: String {
        return "String"
    }
}

extension Int: GQLVariable {
    public static var gqlBaseType: String {
        return "Int"
    }
}

extension Double: GQLVariable {
    public static var gqlBaseType: String {
        return "Float"
    }
}

extension Float: GQLVariable {
    public static var gqlBaseType: String {
        return "Float"
    }
}

extension Bool: GQLVariable {
    public static var gqlBaseType: String {
        return "Boolean"
    }
}

extension Array: GQLVariable where Element: GQLVariable {
    public static var gqlBaseType: String {
        return "[\(Element.gqlVariableType)]"
    }
    
    public static var gqlVariableType: String {
        return "\(gqlBaseType)!"
    }
}

extension Optional: GQLVariable where Wrapped: GQLVariable {
    public static var gqlBaseType: String {
        return Wrapped.gqlBaseType
    }
    
    public static var gqlVariableType: String {
        return gqlBaseType
    }
}
