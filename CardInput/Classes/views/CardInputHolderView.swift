//
//  CardInputHolderView.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit

/// The UIView that gets Credit Card Holder Name. 
internal class CardInputHolderView: UIView, Validation, UITextFieldDelegate {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var fieldHolder: UITextField!
    
    private func commonInit(){
        
        if let bundle = Bundle.cardInputBundle() {
            bundle.loadNibNamed("CardInputHolderView", owner: self, options: nil)
            addSubview(contentView)
        }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.lblTitle.text =  "CARD HOLDER"
        self.fieldHolder.autocorrectionType = .no
        let appearance = Appearance.default
        self.fieldHolder.tintColor = appearance.tintColor
        self.fieldHolder.textColor = appearance.textColor
        self.fieldHolder.delegate = self
        self.fieldHolder.addTarget(self, action: #selector(editingChanged), for: UIControl.Event.editingChanged)
    }
    
    /// MARK - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    
    public func localizedText(holderName: String? = "HOLDER NAME") {
        self.lblTitle.text = holderName
    }
 
    /// MARK - Validation
    private var internalChanged:InputChanged!
    var inputChanged: InputChanged{
        get {
            return internalChanged
        }set {
            internalChanged = newValue
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return self.fieldHolder.becomeFirstResponder()
    }
    
    
    @objc private func editingChanged() {
        let textValue = self.fieldHolder.text ?? ""
        let isValid = textValue.count>0
        
        if textValue.count == 0 {
            self.fieldHolder.textColor = Appearance.default.textColor.withAlphaComponent(0.3)
        }else {
            self.fieldHolder.textColor = Appearance.default.textColor
        }
        self.internalChanged(InputType.cardHolder, InputEvent.editingChanged, textValue, isValid, nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textValue = self.fieldHolder.text ?? ""
        let isValid = textValue.count>0
        
        if textValue.count == 0 {
            self.fieldHolder.textColor = Appearance.default.textColor.withAlphaComponent(0.3)
        }else {
            self.fieldHolder.textColor = Appearance.default.textColor
        }
        self.internalChanged(InputType.cardHolder, InputEvent.endEditing, textValue, isValid, nil)
        textField.resignFirstResponder()
        return true
    }
    
}


