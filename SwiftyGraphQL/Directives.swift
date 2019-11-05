//
//  Directives.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-05.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct Directive {
    let parameter: String
    
    public static func skip(if: GraphQLVariable) -> Directive {
        let parameter = "@skip(if: \(`if`.parameterValue))"
        return Directive(parameter: parameter)
    }
    
    public static func include(if: GraphQLVariable) -> Directive {
        let parameter = "@include(if: \(`if`.parameterValue))"
        return Directive(parameter: parameter)
    }
}
