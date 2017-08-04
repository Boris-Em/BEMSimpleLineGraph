//
//  BEMSimpleLineGraphView.swift
//  SimpleLineChart
//
//  Created by Sam Spencer on 8/4/17.
//  Copyright © 2017 Boris Emorine. All rights reserved.
//

import UIKit

let NullGraphValue: CGFloat = CGFloat.greatestFiniteMagnitude

@IBDesignable public class BEMSimpleLineGraphView_Swift: UIView, UIGestureRecognizerDelegate {
    
    
    /// The object that acts as the delegate of the receiving line graph. 
    /// - remark: The delegate object plays a key role in changing the appearance of the graph and receiving graph events. Use the delegate to provide appearance changes, receive touch events, and receive graph events. The delegate can be set from the interface or from code.  
    weak var delegate: BEMLineGraphDelegate?
    
    /// The object that acts as the data source of the receiving line graph.  
    /// - remark: The data source object is essential to the line graph. Use the data source to provide the graph with data (data points and x-axis labels). The delegate can be set from the interface or from code. 
    /// - note: The data source **must** adopt the `BEMLineGraphDataSource` protocol.
    weak var dataSource: BEMLineGraphDataSource?
    
    
    /// Reload the graph, all delegate methods are called again and the graph is reloaded. Similar to calling reloadData on a UITableView.
    func reloadGraph() {
        
    }

}

protocol BEMLineGraphDataSource: class {
    
    /// The number of points along the X-axis of the graph.  
    /// - parameters:  
    ///     - graph: The graph object requesting the total number of points.  
    /// - returns: The total number of points in the line graph.
    func numberOfPoints(graph: BEMSimpleLineGraphView_Swift) -> Int
    
    /// The vertical position for a point at the given index. It corresponds to the Y-axis value of the Graph.
    /// - parameters:  
    ///     - graph: The graph object requesting the point value.
    ///     - at: The index from left to right of a given point (X-axis). The first value for the index is 0.
    /// - returns: The Y-axis value at a given index.
    func valueForPoint(at: Int, graph: BEMSimpleLineGraphView_Swift)
    
    /// The string to display on the label on the X-axis at a given index.
    /// The number of strings to be returned should be equal to the number of points in the graph (returned in `numberOfPointsInLineGraph`). Otherwise, an exception may be thrown.
    /// - parameters:
    ///     - graph: The graph object which is requesting the label on the specified X-Axis position.
    ///     - at: The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0.
    func labelOnXAxis(at: Int, graph: BEMSimpleLineGraphView_Swift) -> String?
    
}

protocol BEMLineGraphDelegate: class {
    
}
