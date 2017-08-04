//
//  BEMAverageLine.swift
//  SimpleLineGraph
//
//  Created by Sam Spencer on 7/30/17.
//  Copyright © 2017 Samuel Spencer. All rights reserved.
//

import UIKit
import Foundation

struct BEMAverageLine_Swift {
    /// When set to YES, an average line will be displayed on the line graph
    public var enableAverageLine: Bool = false
    
    /// The color of the average line
    public var color: UIColor? = .white

    /// The Y-Value of the average line. This could be an average, a median, a mode, sum, etc.
    public var yValue: CGFloat? = 0.0
    
    /// The alpha of the average line
    public var alpha: CGFloat? = 1.0
    
    /// The width of the average line
    public var width: CGFloat? = 3.0
    
    /// Dash pattern for the average line
    public var dashPattern: [NSNumber]? = []
    
    init(enableAverageLine: Bool, 
         color: UIColor? = .white, 
         yValue: CGFloat? = 0.0,
         alpha: CGFloat? = 1.0,
         width: CGFloat? = 3.0,
         dashPattern: [NSNumber]? = []) {
        self.enableAverageLine = enableAverageLine
        self.color = color
        self.yValue = yValue
        self.alpha = alpha
        self.width = width
        self.dashPattern = dashPattern
    }
}
