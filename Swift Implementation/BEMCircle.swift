//
//  BEMCircle.swift
//  SimpleLineGraph
//
//  Created by Sam Spencer on 7/30/17.
//  Copyright © 2017 Samuel Spencer. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

/// Class to draw the circle for the points (Swift).
class BEMCircle_Swift: UIView {

    /// Set to YES if the data point circles should be constantly displayed. NO if they should only appear when relevant.
    public var shouldDisplayConstantly: Bool = false
    
    /// The point color
    public var color: UIColor = .white
    
    /// The value of the point
    public var absoluteValue: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
     override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: rect)
        color.set()
        context?.fillPath()
     }
}
