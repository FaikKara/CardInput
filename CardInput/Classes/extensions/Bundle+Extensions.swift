//
//  UIBunle+Extensions.swift
//  CardInput
//
//  Created by Sem0043 on 24.09.2018.
//

import Foundation


extension Bundle {
    
    private static let bundleName = "CardInput"
    
    static func cardInputBundle() -> Bundle? {
        let podBundle = Bundle.init(for: CardInputView.classForCoder())
        guard let bundleURL = podBundle.url(forResource: Bundle.bundleName, withExtension: "bundle") else {
            return nil
        }
        return Bundle.init(url: bundleURL)
    }
}


extension UIImage {
    
    convenience init(named imageNamedInBundle:String) {
        self.init(named: imageNamedInBundle, in: Bundle.cardInputBundle(), compatibleWith: nil)
    }
    
}
