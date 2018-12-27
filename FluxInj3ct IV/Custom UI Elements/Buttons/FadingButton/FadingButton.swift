//
//  FadingButton.swift
//  FluxInj3ct IV
//
//  Created by Justin Proulx on 2018-12-22.
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

class FadingButton: UIButton
{
    override var buttonType: ButtonType { return .custom }
    
    override var isHighlighted: Bool
    {
        didSet
        {
            UIView.animate(withDuration: 0.15)
            {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
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
