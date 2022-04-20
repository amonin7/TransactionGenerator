//
//  PKType.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 16.04.2022.
//

import Foundation

/// Represents the of the private key
public enum PKType {
    case wifUncompressed
    case wifCompressed
    case hex
    
    private func regexForCoin() -> String {
        switch self {
        case .hex:
            return "^\\p{XDigit}+$"
        case .wifCompressed:
            return "[KL][1-9A-HJ-NP-Za-km-z]{51}"
        case .wifUncompressed:
            return "^5[HJK][0-9A-Za-z&&[^0OIl]]{49}"
        }
    }
    
    /// Resolves the type of private key by the provided pk
    /// the default value is `wifUncompressed`
    /// - Parameter pk: string with private key
    /// - Returns: type of private key
    static func pkType(for pk: String) -> PKType? {
        let range = NSRange(location: 0, length: pk.utf16.count)
        let resType = [PKType.wifUncompressed, .wifCompressed, .hex].first(where: {
            let regexString = $0.regexForCoin()
            let regex = try? NSRegularExpression(pattern: regexString, options: [])
            return regex?.matches(in: pk, options: [], range: range).count == 1
        })
        if resType == nil {
            return .wifUncompressed
        }
        return resType
    }
}
