// Errors.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct GQLErrorSet: Decodable {
    public let errors: [GQLError]

    public init(errors: [GQLError]) {
        self.errors = errors
    }

    public init?(errors: [GQLError]?) {
        guard let errors = errors else { return nil }
        self.errors = errors
    }
}

extension GQLErrorSet: Error {}
extension GQLErrorSet: LocalizedError {
    public var errorDescription: String? {
        if self.errors.count == 1 {
            return self.errors.first?.localizedDescription
        } else {
            return "Multiple unrecoverable GraphQL© queries/mutations"
        }
    }

    public var failureReason: String? {
        if self.errors.count == 1 {
            return self.errors.first?.failureReason
        } else {
            return "Multiple GraphQL© query/mutation errors."
        }
    }

    public var recoverySuggestion: String? {
        if self.errors.count == 1 {
            return self.errors.first?.recoverySuggestion
        } else {
            return nil
        }
    }
}
