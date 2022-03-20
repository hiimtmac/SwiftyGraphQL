// Response.swift
// Copyright © 2022 hiimtmac

import Foundation

/// All graphql responses come back wrapped in a `data` object
/// in json with an additional array of errors.
public struct GQLResponse<T> {
    public let data: T
    public let errors: [GQLError]?

    public init(data: T, errors: [GQLError]?) {
        self.data = data
        self.errors = errors
    }

    public var error: GQLErrorSet? {
        return GQLErrorSet(errors: self.errors)
    }
}

extension GQLResponse: Decodable where T: Decodable {}
extension GQLResponse: Encodable where T: Encodable {}
