//
//  Directive.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-08.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GQLDirective {
    var gqlDirectiveString: String { get }
}

public struct SkipDirective: GQLDirective {
    let directive: String
    
    public init(if: String) {
        self.directive = `if`
    }
    
    public var gqlDirectiveString: String {
        return "@skip(if: $\(directive))"
    }
}

public struct IncludeDirective: GQLDirective {
    let directive: String
    
    public init(if: String) {
        self.directive = `if`
    }
    
    public var gqlDirectiveString: String {
        return "@include(if: $\(directive))"
    }
}
