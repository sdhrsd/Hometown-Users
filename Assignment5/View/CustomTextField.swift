//
//  CustomTextField.swift
//  Assignment5
//
//  Created by Admin on 11/9/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(replace(_:withText:))) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}
