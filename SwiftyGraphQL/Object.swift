//
//  Object.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLObject {
    static var entityName: String { get }
}

extension GraphQLObject {
    public static var entityName: String {
        let name = "\(Self.self)"
        return name.capitalized
    }
}
