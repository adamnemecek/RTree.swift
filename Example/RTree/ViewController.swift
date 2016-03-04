//
//  ViewController.swift
//  RTree
//
//  Created by Kai Wells on 3/3/16.
//  Copyright © 2016 Kai Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var rtreeView: RTreeView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tree = RTree()
        for _ in 0 ..< 10 {
            let x: Double = MersenneTwister.random()*(Double(self.rtreeView.bounds.size.width) - 20) + 10
            let y: Double = MersenneTwister.random()*(Double(self.rtreeView.bounds.size.height) - 40) + 30
            tree = tree.insert(Point(x, y))
        }
        print(tree.rects().count)
        print(tree.query(Rectangle(Point.Zero, Point(100, 100))).count)
        self.rtreeView.tree = tree
    }

    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .Ended:
            let pos = sender.locationOfTouch(0, inView: self.rtreeView)
            let p = Point(Double(pos.x), Double(pos.y))
            rtreeView.tree = rtreeView.tree.insert(p)
            rtreeView.setNeedsDisplay()
        default:
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

