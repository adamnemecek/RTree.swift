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

// Point Equality and Hashing

extension Point: Equatable {}
func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Point: Hashable {
    var hashValue: Int {
        return self.description.hashValue
    }
}

// Point-Point Arithmetic

func +(lhs: Point, rhs: Point) -> Point {
    return Point(lhs.x + rhs.x, lhs.y + rhs.y)
}

func -(lhs: Point, rhs: Point) -> Point {
    return Point(lhs.x - rhs.x, lhs.y - rhs.y)
}

// Scalar-Point Arithmetic

func *(lhs: Double, rhs: Point) -> Point {
    return Point(lhs*rhs.x, lhs*rhs.y)
}

func *(lhs: Point, rhs: Double) -> Point {
    return rhs*lhs
}

struct Size {
    var w: Double
    var h: Double
    
    init(_ w: Double, _ h: Double) {
        self.w = w
        self.h = h
    }
    
    var area: Double {
        get {
            return self.w*self.h
        }
    }
    
    static let Zero = Size(0, 0)
}

extension Size: CustomStringConvertible {
    var description: String {
        return "{\(self.w), \(self.h)}"
    }
}

func +(lhs: Point, rhs: Size) -> Point {
    return lhs + Point(rhs.w, rhs.h)
}