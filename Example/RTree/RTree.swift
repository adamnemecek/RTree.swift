//
//  RTree.swift
//  RTree
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

public struct RTreeLeaf {
    private var _points: [Point]
    private var _boundingRect: Rectangle
    
    public init() {
        self._points = []
        self._boundingRect = Rectangle.Zero
    }
    
    public init(_ points: [Point]) {
        self._points = points
        self._boundingRect = Rectangle(bounding: points)
    }
    
    public mutating func insert(p: Point) {
        self._points.append(p)
        if self._boundingRect.bounds(p) {
            return
        }
        self._boundingRect = self._boundingRect.expandedToBound(p)
    }
    
    public mutating func remove(p: Point) {
        // Does not shrink the bounding rect!
        self._points = self._points.filter { $0 != p }
    }
    
    public func bounds(p: Point) -> Bool {
        return self._boundingRect.bounds(p)
    }
    
    public mutating func compress() {
        self._boundingRect = Rectangle(bounding: self._points)
    }
    
    public var count: Int {
        return _points.count
    }
}

public struct RTreeNode {
    private var _children: [RTree]
    private var _boundingRect: Rectangle
    
    init() {
        let l = RTreeLeaf()
        self._children = [RTree.Leaf(l)]
        self._boundingRect = l._boundingRect
    }
    
    public mutating func insert(p: Point) {
        if self.childrenBound(p) {
            // find all children that bound p; add p to each
        } else {
            // find child that would expand the least to include p
            if !self.bounds(p) {
                // update bounding rect
            }
        }
    }
    
    public func childrenBound(p: Point) -> Bool {
        return _children.map { $0.bounds(p) }.reduce(false) { $0 || $1 }
    }
    
    public func bounds(p: Point) -> Bool {
        return _boundingRect.bounds(p)
    }
    
    public var count: Int {
        return self._children.map { $0.count }.reduce(0, combine: +)
    }
}

public indirect enum RTree {
    case Leaf(RTreeLeaf)
    case Node(RTreeNode)
    
    init() {
        self = .Leaf(RTreeLeaf([]))
    }
    
    public mutating func insert(p: Point) {
        switch self {
        case .Leaf(var l):
            l.insert(p)
            self = .Leaf(l)
        case .Node(var n):
            n.insert(p)
            self = .Node(n)
        }
    }
    
    public func bounds(p: Point) -> Bool {
        switch self {
        case .Leaf(let l):
            return l.bounds(p)
        case .Node(let n):
            return n.bounds(p)
        }
    }
    
    public var count: Int {
        switch self {
        case .Leaf(let l):
            return l.count
        case .Node(let n):
            return n.count
        }
    }
}