//
//  UIFont+Extensions.swift
//  CardInput
//
//  Created by Sem0043 on 24.09.2018.
//

import Foundation

extension UIFont {
    
    
    internal static func registerDefaultFont(in bundle:Bundle){
        
        let fileName:String = "ocraextended"
        guard let pathForResourceString = bundle.path(forResource: fileName, ofType: "ttf") else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
        
        
        
    }
    
}
