//
//  Geometry.swift
//  RTree
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

struct Point {
    var x: Double
    var y: Double
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    static let Zero = Point(0, 0)
}

extension Point: CustomStringConvertible {
    var description: String {
        return "(\(self.x), \(self.y))"
    }
}