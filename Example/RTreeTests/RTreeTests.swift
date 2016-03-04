//
//  RTreeTests.swift
//  RTreeTests
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

import XCTest
@testable import RTree

class RTreeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPointArithmetic() {
        let a = Point(1, 1)
        let b = Point(2, 1)
        
        let s = a + b
        XCTAssert(s == Point(3, 2), "incorrect addition")
        
        let d = b - a
        XCTAssert(d == Point(1, 0), "incorrect subtraction")
        
        let scale = -1 * a
        XCTAssert(scale == Point(-1, -1), "incorrect scaling")
        
        let third = (1.0 / 3.0)
        let floatingPointError = (third * a + third * b) * 3
        XCTAssert(floatingPointError == s, "floating point errors")
    }
    
    func testRectangleZeroLogic() {
        XCTAssert(Rectangle(origin: Point.Zero, size: Size.Zero).intersects(Rectangle.Zero), "there's a philosophical question in here somewhere")
        XCTAssert(Rectangle(origin: Point.Zero, size: Size(1, 1)).intersects(Rectangle.Zero), "sharing an edge does mean intersection")
        XCTAssert(Rectangle(origin: Point(-1, -1), size: Size(2, 2)).intersects(Rectangle.Zero), "even a point rectangle is inside a real rectangle")
    }
    
    func testRectangleLogic() {
        let o = Point.Zero
        let u = Point(1, 1)
        XCTAssert(Rectangle(o, u) == Rectangle(u, o), "point order does not matter when initializing a rectangle")
        
        let a = Rectangle(o, u)
        let b = Rectangle(origin: Point(0.5, 0.5), size: Size(1, 1))
        XCTAssert(a.intersects(b) == b.intersects(a), "intersection is transposable")
        
        XCTAssertFalse(a.contains(Point(-1, -1)), "outside")
        XCTAssert(a.contains(Point(0, 1)), "edge/corner is still 'inside' a rectangle")
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
