//
//  TopRoundedCornersView.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-14.
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

import UIKit

class TopRoundedCornersView: UIView
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var visualEffectView: UIVisualEffectView!
    
    override func layoutSubviews()
    {
        doCornerRadius()
        setDropShadow()
        setBlur()
    }
    
    func doCornerRadius()
    {
        let cornerRadius = self.bounds.size.width/8
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func setBlur()
    {
        if self.subviews.count > 0
        {
            for subview in self.subviews
            {
                if subview is UIVisualEffectView
                {
                    subview.removeFromSuperview()
                }
            }
        }
        
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        
        self.addSubview(visualEffectView)
        self.sendSubviewToBack(visualEffectView)
        
        for subview in subviews//.reversed()
        {
            if subview != visualEffectView
            {
                self.bringSubviewToFront(subview)
            }
        }
        
        layoutIfNeeded()
    }
    
    func setDropShadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 20
    }

}
