//
//  GraphQLCodeable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLDecodeable: Decodable {}

extension JSONDecoder {
    public func graphQLDecode<T>(_ type: T.Type, from data: Data) throws -> T where T: GraphQLDecodeable {
        do {
            return try decode(type, from: data)
        } catch {
            let graphQLError = try? JSONDecoder().decode(GraphQLError.self, from: data)
            throw graphQLError ?? error
        }
    }
}
