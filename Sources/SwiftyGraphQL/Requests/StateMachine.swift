//
//  StateMachine.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public class SwiftyGraphQL {
    public static let shared = SwiftyGraphQL()
    private init() {}
    
    public var graphQLEndpoint: URL!
    public var queryEncoder = JSONEncoder()
    public var responseDecoder = JSONDecoder()
    public var defaultHeaders: HTTPHeaders = .init([
        HTTPHeader(name: .accept, value: .json),
        HTTPHeader(name: .contentType, value: .json)
    ])
}