//
//  FluxProgressView.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-23.
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

import UIKit

class FluxProgressView: UIProgressView {

    override func didMoveToWindow()
    {
        self.tintColor = .white
        self.trackTintColor = UIColor(red:0.30, green:0.44, blue:0.50, alpha:0.1)
        doCircleRadius()
    }
    
    func doCircleRadius()
    {
        self.layer.cornerRadius = circleRadius()
        self.clipsToBounds = true
        self.layer.sublayers![1].cornerRadius = circleRadius()
        self.subviews[1].clipsToBounds = true
    }
    
    func circleRadius() -> CGFloat
    {
        return 8
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
