//
//  Consraint+UIView.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit



public extension UIView {
    
    
    func fit(to insets:UIEdgeInsets){
        
        guard let superview = self.superview else {
            print("super view is nil")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let margins = superview.layoutMarginsGuide
        self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: insets.left).isActive = true
        self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: insets.right).isActive = true
        self.topAnchor.constraint(equalTo: margins.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: insets.bottom).isActive = true
        
    }
    
    
    func fix(to height:CGFloat? = nil, width:CGFloat? = nil){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let h = height {
            self.heightAnchor.constraint(equalToConstant: h).isActive = true
        }
        
        if let w = width {
            self.widthAnchor.constraint(equalToConstant: w).isActive = true
        }
        
    }
    
}

