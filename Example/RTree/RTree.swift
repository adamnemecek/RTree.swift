//
//  RTree.swift
//  RTree
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

public struct RTreeLeaf<Value> {
    private var _points: [Point]
    private var _pointDict: [Point: Value]
    private var _boundingRect: Rectangle
    
    public init() {
        self._points = []
        self._pointDict = [:]
        self._boundingRect = Rectangle.Zero
    }
    
    public init(_ points: [Point]) {
        self._points = points
        self._pointDict = [:]
        self._boundingRect = Rectangle(bounding: points)
    }
    
    public init(_ pointsAndValues: [Point: Value]) {
        self._points = []
        self._pointDict = pointsAndValues
        for p in pointsAndValues.keys {
            self._points.append(p)
        }
        self._boundingRect = Rectangle(bounding: self._points)
    }
    
    public mutating func insert(at p: Point, value v: Value) {
        self._points.append(p)
        self._pointDict[p] = v
        
        if self._boundingRect.contains(p) {
            return
        }
        self._boundingRect = self._boundingRect.expandedToBound(p)
    }
    
    public mutating func remove(at p: Point) -> Value? {
        // Does not shrink the bounding rect!
        return self._pointDict.removeValueForKey(p)
    }
    
    public func valueAt(p: Point) -> Value? {
        return self._pointDict[p]
    }
    
    public func hasValueAt(p: Point) -> Bool {
        if let _ = self._pointDict[p] {
            return true
        }
        return false
    }
    
    public func contains(p: Point) -> Bool {
        return self._boundingRect.contains(p)
    }
    
    public mutating func compress() {
        self._boundingRect = Rectangle(bounding: self._points)
    }
}