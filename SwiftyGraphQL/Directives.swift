//
//  Directives.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-05.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public enum Directive {
    case include(if: Bool)
    case skip(if: Bool)
}
