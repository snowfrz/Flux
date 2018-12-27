//
//  TwitterButton.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-22.
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

import UIKit

class TwitterButton: ImpressionableButton
{

    override func didMoveToWindow()
    {
        super.didMoveToWindow()
        setColors()
        doCircleRadius()
        self.contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        setupShadow()
        setColors()
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
    
    func setupShadow()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        self.layer.shadowOpacity = 0.1
    }
}
