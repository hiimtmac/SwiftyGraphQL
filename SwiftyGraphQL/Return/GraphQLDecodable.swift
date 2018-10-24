//
//  GraphQLCodeable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLDecodable: Decodable {}
extension String: GraphQLDecodable {}
extension Array: GraphQLDecodable where Element: GraphQLDecodable {}

extension JSONDecoder {
    public func graphQLDecode<T>(_ type: T.Type, from data: Data) throws -> T where T: GraphQLDecodable {
        do {
            return try decode(type, from: data)
        } catch {
            let graphQLError = try? JSONDecoder().decode(GraphQLErrors.self, from: data)
            throw graphQLError ?? error
        }
    }
}
