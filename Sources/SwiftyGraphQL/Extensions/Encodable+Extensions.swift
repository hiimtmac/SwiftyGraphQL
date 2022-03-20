// Encodable+Extensions.swift
// Copyright © 2022 hiimtmac

import Foundation

extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
