//
//  ViewController.swift
//  SimpleLineChart-Swift
//
//  Created by Sam Spencer on 8/4/17.
//  Copyright © 2017 Boris Emorine. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate {
    
    let dataSource = [5, 16, 8, 3, 10]
    let labels = ["1", "2", "3", "4", "5"]
    
    func numberOfPoints(inLineGraph graph: BEMSimpleLineGraphView) -> UInt {
        return 5
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, valueForPointAt index: UInt) -> CGFloat {
        return CGFloat(dataSource[Int(index)])
    }
    
    func lineGraph(_ graph: BEMSimpleLineGraphView, labelOnXAxisFor index: UInt) -> String? {
        return labels[Int(index)]
    }
    
    func numberOfGapsBetweenLabels(onLineGraph graph: BEMSimpleLineGraphView) -> UInt {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let graph = BEMSimpleLineGraphView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        graph.dataSource = self
        graph.delegate = self
        
        graph.enableTouchReport = true
        graph.enablePopUpReport = true
        graph.enableBezierCurve = true
        graph.widthLine = 3.0
        graph.enableReferenceAxisFrame = true
        graph.enableReferenceXAxisLines = true
        graph.enableReferenceYAxisLines = true
        graph.enableYAxisLabel = true
        
        // Apply a gradient to the bottom portion of the graph
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let num_locations: size_t = 2
        let locations: [CGFloat] = [0.0, 1.0]
        let components: [CGFloat] = [0.976, 0.678, 0.298, 1.0, 0.98, 0.2196, 0.1961, 1.0]
        let gradient: CGGradient = CGGradient(colorSpace: colorspace, colorComponents: components, locations: locations, count: num_locations)!
        graph.gradientBottom = gradient
        
        graph.colorTop = .black
        graph.colorLine = .white
        graph.colorXaxisLabel = .white
        graph.colorYaxisLabel = .white
        graph.colorBackgroundXaxis = UIColor.init(red: 0.98, green: 0.2196, blue: 0.1961, alpha: 1.0)
        graph.backgroundColor = UIColor.init(red: 0.98, green: 0.2196, blue: 0.1961, alpha: 1.0)
        
        view.addSubview(graph)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

