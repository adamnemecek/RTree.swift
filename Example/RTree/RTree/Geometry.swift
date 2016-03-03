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

// Convenience function for rectangles
func +(lhs: Point, rhs: Size) -> Point {
    return lhs + Point(rhs.w, rhs.h)
}

struct Rectangle {
    let origin: Point
    let size: Size
    
    var area: Double {
        get {
            return size.w*size.h
        }
    }
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    init(_ a: Point, _ b: Point) {
        let d = b - a
        self.origin = Point(min(a.x, b.x), min(a.y, b.y))
        self.size = Size(abs(d.x), abs(d.y))
    }
    
    static let Zero: Rectangle = Rectangle(Point.Zero, Point.Zero)
}

extension Rectangle: CustomStringConvertible {
    var description: String {
        return "[\(self.origin) \(self.size)]"
    }
}

extension Rectangle {
    func contains(p: Point) -> Bool {
        let d = p - self.origin
        return d.x > 0 && d.x <= self.size.w && d.y > 0 && d.y <= self.size.h
    }
    
    var corners: [Point] {
        get {
            let a = self.origin
            let b = self.origin + Point(self.size.w, 0)
            let c = self.origin + Point(0, self.size.h)
            let d = self.origin + self.size
            return [a, b, c, d]
        }
    }
    
    func intersects(r: Rectangle) -> Bool {
        return r.corners
            .map(self.contains)
            .reduce(false) { $0 || $1 }
    }
}