//
//  Base58.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 17.04.2022.
//

import Foundation

public struct Base58 {

    // MARK: - Public Properties
    static let baseAlphabets = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    static var zeroAlphabet: Character = "1"
    static var base: Int = 58

    // MARK: - Public Methods
    static func sizeFromByte(size: Int) -> Int {
        return size * 138 / 100 + 1
    }
    static func sizeFromBase(size: Int) -> Int {
        return size * 733 / 1000 + 1
    }
    
    static func convertBytesToBase(_ bytes: Data) -> [UInt8] {
        var length = 0
        let size = sizeFromByte(size: bytes.count)
        var encodedBytes: [UInt8] = Array(repeating: 0, count: size)
        
        for b in bytes {
            var carry = Int(b)
            var i = 0
            for j in (0...encodedBytes.count - 1).reversed() where carry != 0 || i < length {
                carry += 256 * Int(encodedBytes[j])
                encodedBytes[j] = UInt8(carry % base)
                carry /= base
                i += 1
            }
            
            assert(carry == 0)
            
            length = i
        }
        
        var zerosToRemove = 0
        for b in encodedBytes {
            if b != 0 { break }
            zerosToRemove += 1
        }
        
        encodedBytes.removeFirst(zerosToRemove)
        return encodedBytes
    }
    
    static func decode(address: String) -> Data {
        let dec = decode(address)
        let conv = convertBytesToBase(dec)
//        guard conv.count >= 2 && conv.count <= 40 else {
//            throw CoderError.dataSizeMismatch(conv.count)
//        }
//        guard dec.checksum[0] <= 16 else {
//            throw CoderError.segwitVersionNotSupported(dec.checksum[0])
//        }
//        if dec.checksum[0] == 0 && conv.count != 20 && conv.count != 32 {
//            throw CoderError.segwitV0ProgramSizeMismatch(conv.count)
//        }
        return Data() + conv
    }
        
    static func decode(_ string: String) -> Data {
        guard !string.isEmpty else { return Data() }
        
        var zerosCount = 0
        var length = 0
        for c in string {
            if c != zeroAlphabet { break }
            zerosCount += 1
        }
        let size = sizeFromBase(size: string.lengthOfBytes(using: .utf8) - zerosCount)
        var decodedBytes: [UInt8] = Array(repeating: 0, count: size)
        for c in string {
            guard let baseIndex = baseAlphabets.firstIndex(of: c) else { return Data() }
            
            var carry = baseIndex.utf16Offset(in: baseAlphabets)
            var i = 0
            for j in (0...decodedBytes.count - 1).reversed() where carry != 0 || i < length {
                carry += base * Int(decodedBytes[j])
                decodedBytes[j] = UInt8(carry % 256)
                carry /= 256
                i += 1
            }
            
            assert(carry == 0)
            length = i
        }
        // skip leading zeros
        var zerosToRemove = 0
        for b in decodedBytes {
            if b != 0 { break }
            zerosToRemove += 1
        }
        decodedBytes.removeFirst(zerosToRemove)
        return Data(repeating: 0, count: zerosCount) + Data(decodedBytes)
    }
}
