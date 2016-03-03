//
//  Geometry.swift
//  RTree
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

public struct Point {
    var x: Double
    var y: Double
    
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    static let Zero = Point(0, 0)
}

extension Point: CustomStringConvertible {
    public var description: String {
        return "(\(self.x), \(self.y))"
    }
}

// Point Equality and Hashing

extension Point: Equatable {}
public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Point: Hashable {
    public var hashValue: Int {
        return self.description.hashValue
    }
}

// Point-Point Arithmetic

public func +(lhs: Point, rhs: Point) -> Point {
    return Point(lhs.x + rhs.x, lhs.y + rhs.y)
}

public func -(lhs: Point, rhs: Point) -> Point {
    return Point(lhs.x - rhs.x, lhs.y - rhs.y)
}

// Scalar-Point Arithmetic

public func *(lhs: Double, rhs: Point) -> Point {
    return Point(lhs*rhs.x, lhs*rhs.y)
}

public func *(lhs: Point, rhs: Double) -> Point {
    return rhs*lhs
}

public struct Size {
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
    public var description: String {
        return "{\(self.w), \(self.h)}"
    }
}

// Convenience function for rectangles
internal func +(lhs: Point, rhs: Size) -> Point {
    return lhs + Point(rhs.w, rhs.h)
}

public struct Rectangle {
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
    
    init(bounding points: [Point]) {
        guard points.count > 0 else {
            self = Rectangle.Zero
            return
        }
        var a = points.first!
        var b = points.first!
        for p in points {
            a.x = min(a.x, p.x); a.y = min(a.y, p.y)
            b.x = max(b.x, p.x); b.y = max(b.y, p.y)
        }
        self = Rectangle(a, b)
    }
    
    static let Zero: Rectangle = Rectangle(Point.Zero, Point.Zero)
}

extension Rectangle: CustomStringConvertible {
    public var description: String {
        return "[\(self.origin) \(self.size)]"
    }
}

extension Rectangle {
    public func contains(p: Point) -> Bool {
        let d = p - self.origin
        return d.x > 0 && d.x <= self.size.w && d.y > 0 && d.y <= self.size.h
    }
    
    public var corners: [Point] {
        get {
            let a = self.origin
            let b = self.origin + Point(self.size.w, 0)
            let c = self.origin + Point(0, self.size.h)
            let d = self.origin + self.size
            return [a, b, c, d]
        }
    }
    
    public func intersects(r: Rectangle) -> Bool {
        return r.corners
            .map(self.contains)
            .reduce(false) { $0 || $1 }
    }
}