//
//  ImpressionableButton.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-21.
//  Based on the Objective-C version of ImpressionableButton by AppleBetas, created on 2017-07-02
//
//  Copyright © 2018 New Year's Development Team. All rights reserved.
//

//****************************************************************************************************
//
//
//  IMPORTANT TO REMEMBER: WHILE USING THIS CLASS, SET EACH BUTTON TO TYPE OF CUSTOM EITHER IN STORYBOARDS OR CODE.
//
//
//****************************************************************************************************

import UIKit

class ImpressionableButton: UIButton
{
    override var buttonType: ButtonType { return .custom }
    
    override var isHighlighted: Bool
    {
        didSet
        {
            UIView.animate(withDuration: 0.15)
            {
                self.alpha = self.isHighlighted ? 0.8 : 1.0
                self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
            }
        }
    }
    
    override var isEnabled: Bool
    {
        didSet
        {
            //super.isEnabled
            UIView.animate(withDuration: 0.15)
            {
                self.alpha = self.isEnabled ? 1.0 : 0.5
            }
        }
    }
}


