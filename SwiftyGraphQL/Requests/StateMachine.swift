//
//  StateMachine.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

public import Foundation

class SwiftyGraphQL {
    public static let shared = SwiftyGraphQL()
    private init() {}
    
    public var graphQLEndpoint: URL!
    public var queryEncoder: JSONEncoder?
    public var responseDecoder: JSONDecoder?
}
