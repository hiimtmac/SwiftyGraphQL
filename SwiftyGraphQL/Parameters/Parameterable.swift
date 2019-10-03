//
//  Parameterable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-10-03.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLParameterable {
    func graphQLParameterEncode() -> GraphQLParameters
}
