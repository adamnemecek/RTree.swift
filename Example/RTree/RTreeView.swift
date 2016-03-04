//
//  RTreeView.swift
//  RTree
//
//  Created by Kai Wells on 3/4/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

import UIKit
import RTree

public extension Point {
    init(cgrep: CGPoint) {
        self = Point.init(Double(cgrep.x), Double(cgrep.y))
    }
    
    var CGRep: CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}

extension Size {
    init(cgrep: CGSize) {
        self = Size.init(Double(cgrep.width), Double(cgrep.height))
    }
    
    var CGRep: CGSize {
        return CGSize(width: self.w, height: self.h)
    }
}

extension Rectangle {
    init(cgrep: CGRect) {
        self = Rectangle.init(origin: Point(cgrep: cgrep.origin), size: Size(cgrep: cgrep.size))
    }
    
    var CGRep: CGRect {
        return CGRect(origin: self.origin.CGRep, size: self.size.CGRep)
    }
}

class RTreeView: UIView {
    
    var tree = RTree()
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 1)
        for p in tree.query(Rectangle.init(cgrep: rect)) {
            let r = Rectangle(origin: p, size: Size(1,1))
            CGContextFillRect(context, r.CGRep)
        }
        
        CGContextSetRGBFillColor(context, 0, 0, 0, 0)
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 0.5)
        for r in tree.rects() {
            CGContextStrokeRect(context, r.CGRep)
        }
    }

}
