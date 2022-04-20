//
//  DataExtentions.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// the implementation of + between two Data types
extension Data: ConvertibleInteger {
    static func + (l: Data, r: Data) -> Data {
        var data = Data()
        data.append(l)
        data.append(r)
        return data
    }
}

/// the implementation of double SHA256 function applied to the Data type
extension Data {
    var doubleSHA256: Data {
        return self.sha256().sha256()
    }
}
