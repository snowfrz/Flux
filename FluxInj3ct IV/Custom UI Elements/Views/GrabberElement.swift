//
//  GrabberElement.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-23.
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

import UIKit

class GrabberElement: UIView {

    override func layoutSubviews()
    {
        doCircleRadius()
    }
    
    override func didMoveToWindow()
    {
        doCircleRadius()
    }
    
    func doCircleRadius()
    {
        self.layer.cornerRadius = min(self.bounds.size.width, self.bounds.size.height) / 2
    }
}
