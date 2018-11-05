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
    @IBOutlet weak var fieldCvv: UITextField!
    
    private func commonInit(){
        
        
        if let bundle = Bundle.cardInputBundle() {
            bundle.loadNibNamed("CardInputValidThruView", owner: self, options: nil)
            addSubview(contentView)
        }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fieldValidThru.maskDelegate = self;
        fieldCvv.delegate = self;
        
        fieldValidThru.keyboardType = .numberPad
        fieldCvv.keyboardType = .numberPad
        
        let appearance = Appearance.default
        fieldValidThru.tintColor = appearance.tintColor
        fieldValidThru.textColor = appearance.textColor.withAlphaComponent(0.3)
        
        fieldCvv.tintColor = appearance.tintColor
        fieldCvv.textColor = appearance.textColor.withAlphaComponent(0.3)
        fieldCvv.addTarget(self, action: #selector(editingChanged), for: UIControl.Event.editingChanged)
        self.addToolbar()
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

    
    private func addToolbar(){
        let toolbar = UIToolbar.init()
        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        let done = UIBarButtonItem.init(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneTapped))
        let flexible = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexible, done]
        toolbar.sizeToFit()
        self.fieldCvv.inputAccessoryView = toolbar
    }
    
    @objc private func doneTapped(){
        self.fieldCvv.resignFirstResponder()
    }
    
}

extension CardInputValidThruView: AKMaskFieldDelegate {
    
    func maskFieldDidBeginEditing(_ maskField: AKMaskField) {
        let isValid = maskField.isValid()
        if maskField == self.fieldValidThru {
            self.internalInputChanged(InputType.validThru, InputEvent.beginEditing, self.rawValue(in: maskField), isValid, nil)
        }
    }
    
    func maskFieldDidEndEditing(_ maskField: AKMaskField) {
        let isValid = maskField.isValid()
        if maskField == self.fieldValidThru {
            self.internalInputChanged(InputType.validThru, InputEvent.endEditing, self.rawValue(in: maskField), isValid, nil)
        }
    }
    
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        
        var isValid = false
        switch maskField.maskStatus {
        case .clear:
            maskField.textColor = Appearance.default.textColor.withAlphaComponent(0.3)
            break
        case .incomplete:
            maskField.textColor = Appearance.default.textColor
            break
        case .complete:
            maskField.textColor = Appearance.default.textColor
            isValid = true
            break
        }
        if maskField == self.fieldValidThru {
            self.internalInputChanged(InputType.validThru, InputEvent.editingChanged, self.rawValue(in: maskField), isValid, nil)
            if isValid {
                self.fieldCvv.becomeFirstResponder()
            }
        }
        
    }
}


extension CardInputValidThruView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != fieldCvv { return true }
        
        let newText = "\(textField.text.safeValue)\(string)"
        return newText.count <= 4
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text.safeValue
        let isValid = false//text.count > 0
        self.internalInputChanged(InputType.cvv, InputEvent.beginEditing, text, isValid, nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text.safeValue
        let isValid = false//text.count > 0
        self.internalInputChanged(InputType.cvv, InputEvent.endEditing, text, isValid, nil)
    }
    
    @objc private func editingChanged() {
        let textValue = self.fieldCvv.text.safeValue
        let isValid = false//textValue.count>0
        
        if textValue.count == 0 {
            self.fieldCvv.textColor = Appearance.default.textColor.withAlphaComponent(0.3)
        }else {
            self.fieldCvv.textColor = Appearance.default.textColor
        }
        
        self.internalInputChanged(InputType.cvv, InputEvent.editingChanged, textValue, isValid, nil)
    }
}

fileprivate extension CardInputValidThruView {
    
    func rawValue(in maskField: AKMaskField) -> String {
        guard let maskedText = maskField.text else { return ""}
        return maskedText.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "*", with: "")
    }
}


private extension Swift.Optional where Wrapped == String {
    var safeValue: String {
        guard let val = self else {
            return ""
        }
        return val
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
