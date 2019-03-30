//
//  StateMachine.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

class SwiftyGraphQL {
    public static let shared = SwiftyGraphQL()
    private init() {}
    
    var graphQLEndpoint: URL!
    var queryEncoder: JSONEncoder?
    var responseDecoder: JSONDecoder?
}
