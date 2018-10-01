//
//  Appearance.swift
//  CardInput
//
//  Created by Sem0043 on 19.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import Foundation
import UIKit

/**
 Appearance for input fields.
 So for it's not covering all view components.
 
 - TODO:
    - implement font attributes for input fields
    - implement image attributes for card brands
 */
public struct Appearance {
    
    let tintColor:UIColor
    let textColor:UIColor
    
    init(tintColor:UIColor, textColor:UIColor) {
        self.tintColor = tintColor
        self.textColor = textColor
    }
    
    private static var internalAppearance:Appearance = createDefault()
    static var `default`:Appearance {
        get {
            return self.internalAppearance
        }set{
            internalAppearance = newValue
        }
    }
    
}


private extension Appearance {
    private static func createDefault() -> Appearance {
        return Appearance(tintColor: UIColor.darkGray, textColor:UIColor.black)
    }
}
