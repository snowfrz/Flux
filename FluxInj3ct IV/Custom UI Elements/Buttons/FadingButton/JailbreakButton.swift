//
//  JailbreakButton.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-22.
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

import UIKit

class JailbreakButton: FadingButton
{
    override func didMoveToWindow()
    {
        super.didMoveToWindow()
        doCircleRadius()
        setColors()
        self.contentEdgeInsets = UIEdgeInsets.init(top: 16, left: 30, bottom: 16, right: 30)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        doCircleRadius()
    }
    
    func setColors()
    {
        self.backgroundColor = self.tintColor
        self.setTitleColor(.white, for: .normal)
    }
    
    func doCircleRadius()
    {
        self.layer.cornerRadius = min(self.bounds.size.width, self.bounds.size.height) / 4
    }
}
