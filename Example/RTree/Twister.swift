//
//  Twister.swift
//  Mersenne
//
//  Created by Kai Wells on 11/25/15.
//  Copyright © 2015 Kai Wells. All rights reserved.
//

import Foundation

private func safeMultiply(a: UInt32, _ b: UInt32) -> UInt32 {
    let ah = UInt64(a & 0xFFFF0000) >> 16
    let al = UInt64(a & 0x0000FFFF)
    let bh = UInt64(b & 0xFFFF0000) >> 16
    let bl = UInt64(b & 0x0000FFFF)
    
    //let F  = ah * bh // << 32
    let OI = ah * bl + al * bh // << 16
    let L  = al * bl
    
    let result = (((OI << 16) & 0xFFFFFFFF) + L) & 0xFFFFFFFF
    return UInt32(result)
}

public final class TwisterGenerator: GeneratorType {
    
    public typealias Element = UInt32
    
    private let (w, n, m, r): (UInt32, Int, Int, UInt32) = (32, 624, 397, 31)
    private let a: UInt32 = 0x9908B0DF
    private let (u, d): (UInt32, UInt32) = (11, 0xFFFFFFFF)
    private let (s, b): (UInt32, UInt32) = ( 7, 0x9D2C5680)
    private let (t, c): (UInt32, UInt32) = (15, 0xEFC60000)
    private let l: UInt32 = 18
    private let f: UInt32 = 1812433253
    
    public let maxValue: UInt32 = 4294967295
    
    private var state: [UInt32]
    private var index = 0
    
    public init(seed: UInt32 = 5489) {
        var x = [seed]
        for i in 1..<n {
            let prev = x[i-1]
            let c = safeMultiply(f, prev ^ (prev >> (w-2))) + UInt32(i)
            x.append(c)
        }
        self.state = x
    }
    
    private func twist() {
        for i in 0..<n {
            let x = (state[i] & 0xFFFF0000) + ((state[(i+1) % n] % UInt32(n)) & 0x0000FFFF)
            var xA = x >> 1
            if (x % 2 != 0) {
                xA = xA ^ a
            }
            state[i] = state[(i + m) % n] ^ xA
            index = 0
        }
    }
    
    public func next() -> UInt32? {
        if self.index > n { fatalError("Generator never seeded") }
        if self.index == n { self.twist() }
        
        var y = state[index++]
        y = y ^ ((y >> u) & d)
        y = y ^ ((y << s) & b)
        y = y ^ ((y << t) & c)
        y = y ^ (y >> 1)
        
        return y
    }
}

public struct MersenneTwister {
    
    private static let generator = TwisterGenerator(seed: UInt32(NSDate().timeIntervalSince1970 % 4294967296))
    
    static func random() -> Double {
        return Double(generator.next()!) / Double(generator.maxValue)
    }
    
    static func random() -> Float {
        return Float(generator.next()!) / Float(generator.maxValue)
    }
    
}