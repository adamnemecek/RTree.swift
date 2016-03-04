//
//  RTree.swift
//  RTree
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

private struct RTreeLeaf {
    var _points: [Point]
    var _boundingRect: Rectangle
    
    static var maxPoints = 16
    
    init() {
        self._points = []
        self._boundingRect = Rectangle.Zero
    }
    
    init(_ points: [Point]) {
        self._points = points
        self._boundingRect = Rectangle(bounding: points)
    }
    
    func insert(p: Point) -> (RTreeLeaf, RTreeLeaf?) {
        var copy = self
        copy._points.append(p)
        if copy._points.count >= RTreeLeaf.maxPoints {
            if MersenneTwister.random() < 0.5 {
                let m = copy._points.map { $0.x }.reduce(0, combine: +)/Double(copy._points.count)
                let l = copy._points.filter { $0.x <= m }
                let r = copy._points.filter { $0.x > m }
                return (RTreeLeaf(l), RTreeLeaf(r))
            }
            let m = copy._points.map { $0.y }.reduce(0, combine: +)/Double(copy._points.count)
            let l = copy._points.filter { $0.y <= m }
            let r = copy._points.filter { $0.y > m }
            return (RTreeLeaf(l), RTreeLeaf(r))
        }
        if copy._boundingRect.bounds(p) {
            return (copy, nil)
        }
        copy._boundingRect = copy._boundingRect.expandedToBound(p)
        return (copy, nil)
    }
    
    func remove(p: Point) -> RTreeLeaf {
        // Does not shrink the bounding rect!
        var copy = self
        copy._points = copy._points.filter { $0 != p }
        return copy
    }
    
    func bounds(p: Point) -> Bool {
        return self._boundingRect.bounds(p)
    }
    
    func compress() -> RTreeLeaf {
        var copy = self
        copy._boundingRect = Rectangle(bounding: copy._points)
        return copy
    }
    
    func query(r: Rectangle) -> [Point] {
        var results = [Point]()
        for p in self._points {
            if r.bounds(p) {
                results.append(p)
            }
        }
        return results
    }
    
    var count: Int {
        return _points.count
    }
}

private struct RTreeNode {
    var _children: [RTreeInternal]
    var _boundingRect: Rectangle
    
    init() {
        let l = RTreeLeaf()
        self._children = [RTreeInternal.Leaf(l)]
        self._boundingRect = l._boundingRect
    }
    
    init(leaves: [RTreeLeaf]) {
        self._children = leaves.map { RTreeInternal.Leaf($0) }
        let corners = leaves.map { $0._boundingRect.corners }.reduce([], combine: +)
        self._boundingRect = Rectangle(bounding: corners)
    }
    
    func insert(p: Point) -> RTreeNode {
        var copy = self
        if self.childrenBound(p) {
            copy._children = self._children.map { $0.bounds(p) ? $0.insert(p) : $0 }
        } else {
            // find child that would expand the least to include p
            let dAs = self._children.map { $0.insert(p)._boundingRect.area - $0._boundingRect.area }
            let m = dAs.indexOf { $0 == dAs.minElement()! }!
            copy._children[m] = copy._children[m].insert(p)
            if !self.bounds(p) {
                // update bounding rect
                let allCorners = copy._children.map { $0._boundingRect.corners }.reduce([], combine: +)
                copy._boundingRect = Rectangle(bounding: allCorners)
            }
        }
        return copy
    }
    
    func remove(p: Point) -> RTreeNode {
        // Does not shrink bounding rects
        var copy = self
        copy._children = self._children.map { $0.remove(p) }
        return copy
    }
    
    func childrenBound(p: Point) -> Bool {
        return _children.map { $0.bounds(p) }.reduce(false) { $0 || $1 }
    }
    
    func bounds(p: Point) -> Bool {
        return _boundingRect.bounds(p)
    }
    
    func query(r: Rectangle) -> [Point] {
        return self._children.map { $0.query(r) }.reduce([], combine: +)
    }
    
    func compress() -> RTreeNode {
        var copy = self
        copy._children = copy._children.map { $0.compress() }
        return copy
    }
    
    var count: Int {
        return self._children.map { $0.count }.reduce(0, combine: +)
    }
}

private indirect enum RTreeInternal {
    case Leaf(RTreeLeaf)
    case Node(RTreeNode)
    
    var _boundingRect: Rectangle {
        switch self {
        case .Leaf(let l):
            return l._boundingRect
        case .Node(let n):
            return n._boundingRect
        }
    }
    
    init() {
        self = .Leaf(RTreeLeaf([]))
    }
    
    func insert(p: Point) -> RTreeInternal {
        switch self {
        case .Leaf(let L):
            let (l, r) = L.insert(p)
            if let r = r {
                let n = RTreeNode(leaves: [l, r])
                return .Node(n)
            }
            return .Leaf(l)
        case .Node(let n):
            return .Node(n.insert(p))
        }
    }
    
    func remove(p: Point) -> RTreeInternal {
        switch self {
        case .Leaf(let l):
            return .Leaf(l.remove(p))
        case .Node(let n):
            return .Node(n.remove(p))
        }
    }
    
    func bounds(p: Point) -> Bool {
        switch self {
        case .Leaf(let l):
            return l.bounds(p)
        case .Node(let n):
            return n.bounds(p)
        }
    }
    
    func query(r: Rectangle) -> [Point] {
        switch self {
        case .Leaf(let l):
            return l.query(r)
        case .Node(let n):
            return n.query(r)
        }
    }
    
    func compress() -> RTreeInternal {
        switch self {
        case .Leaf(let l):
            return .Leaf(l.compress())
        case .Node(let n):
            return .Node(n.compress())
        }
    }
    
    func rects() -> [Rectangle] {
        switch self {
        case .Leaf(let l):
            return [l._boundingRect]
        case .Node(let n):
            return [n._boundingRect] + n._children.map { $0.rects() }.reduce([], combine: +)
        }
    }
    
    var count: Int {
        switch self {
        case .Leaf(let l):
            return l.count
        case .Node(let n):
            return n.count
        }
    }
    
    func leafcount() -> Int {
        switch self {
        case .Leaf(_):
            return 1
        case .Node(let n):
            return n._children.map { $0.leafcount() }.reduce(0, combine: +)
        }
    }
}

public struct RTree {
    private var _internalRep = RTreeInternal()
    
    public init() {
        
    }
    
    public func insert(p: Point) -> RTree {
        var copy = self
        copy._internalRep = self._internalRep.insert(p)
        return copy
    }
    
    public func remove(p: Point) -> RTree {
        var copy = self
        copy._internalRep = self._internalRep.remove(p)
        return copy
    }
    
    public func query(r: Rectangle) -> [Point] {
        return self._internalRep.query(r)
    }
    
    public func rects() -> [Rectangle] {
        return self._internalRep.rects()
    }
    
    public func leafcount() -> Int {
        return self._internalRep.leafcount()
    }
    
    public var count: Int {
        return self._internalRep.count
    }
}