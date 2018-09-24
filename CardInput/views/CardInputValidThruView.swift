//
//  CardInputValidThruView.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit
import AKMaskField

/// The UIView that gets Credit Card Valid Thru date and CVV. Date format is MM/YY.
internal class CardInputValidThruView: UIView, Validation {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fieldValidThru: AKMaskField!
    @IBOutlet weak var fieldCvv: AKMaskField!
    
    private func commonInit(){
        
        
        if let bundle = Bundle.cardInputBundle() {
            bundle.loadNibNamed("CardInputValidThruView", owner: self, options: nil)
            addSubview(contentView)
        }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fieldValidThru.maskDelegate = self;
        fieldCvv.maskDelegate = self;
        
        fieldValidThru.keyboardType = .numberPad
        fieldCvv.keyboardType = .numberPad
        
        let appearance = Appearance.default
        fieldValidThru.tintColor = appearance.tintColor
        fieldValidThru.textColor = appearance.textColor
        
        fieldCvv.tintColor = appearance.tintColor
        fieldCvv.textColor = appearance.textColor
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    
    // MARK: - Validation
    private var internalInputChanged: InputChanged!
    var inputChanged: InputChanged {
        get {
            return internalInputChanged
        }set {
            internalInputChanged = newValue
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        if self.fieldValidThru.isFirstResponder {
            return self.fieldCvv.becomeFirstResponder()
        }else{
            return self.fieldValidThru.becomeFirstResponder()
        }
    }

}

extension CardInputValidThruView: AKMaskFieldDelegate, UITextFieldDelegate {
    
    func maskFieldDidBeginEditing(_ maskField: AKMaskField) {
        let isValid = maskField.isValid()
        if maskField == self.fieldValidThru {
            self.internalInputChanged(InputType.validThru, InputEvent.beginEditing, self.rawValue(in: maskField), isValid)
        }else if maskField == self.fieldCvv {
            self.internalInputChanged(InputType.cvv, InputEvent.beginEditing, self.rawValue(in: maskField), isValid)
        }
    }
    
    func maskFieldDidEndEditing(_ maskField: AKMaskField) {
        let isValid = maskField.isValid()
        if maskField == self.fieldValidThru {
            self.internalInputChanged(InputType.validThru, InputEvent.endEditing, self.rawValue(in: maskField), isValid)
        }else if maskField == self.fieldCvv {
            self.internalInputChanged(InputType.cvv, InputEvent.endEditing, self.rawValue(in: maskField), isValid)
        }
    }
    
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        
        var isValid = false
        switch maskField.maskStatus {
        case .clear,.incomplete:
            break
        case .complete:
            isValid = true
            break
        }
        if maskField == self.fieldValidThru {
            self.internalInputChanged(InputType.validThru, InputEvent.editingChanged, self.rawValue(in: maskField), isValid)
            if isValid {
                self.fieldCvv.becomeFirstResponder()
            }
        }else if maskField == self.fieldCvv {
            self.internalInputChanged(InputType.cvv, InputEvent.editingChanged, self.rawValue(in: maskField), isValid)
        }
        
    }
}

fileprivate extension CardInputValidThruView {
    
    func rawValue(in maskField: AKMaskField) -> String {
        
        guard let maskedText = maskField.text else { return ""}
        return maskedText.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "*", with: "")
        
    }
}



extension AKMaskField {
    
    func isValid() -> Bool {
        
        var isValid = false
        switch self.maskStatus {
        case .clear,.incomplete:
            break
        case .complete:
            isValid = true
            break
        }
        return isValid
    }
    
}
