//
//  CardInputNumberView.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit
import AKMaskField


private struct CardNumber {
    static let charset:CharacterSet = CharacterSet.init(charactersIn: "0123456789")
    static let max_length:Int = 16
}

internal class CardInputNumberView: UIView, Validation {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fieldCard: AKMaskField!
    @IBOutlet weak var lblTitle: UILabel!
    
    private func commonInit(){
        
        if let bundle = Bundle.cardInputBundle() {
            bundle.loadNibNamed("CardInputNumberView", owner: self, options: nil)
            addSubview(contentView)
        }

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.lblTitle.text = "CARD NUMBER"
        self.fieldCard.maskDelegate = self
        self.fieldCard.keyboardType = .numberPad
        
        let appearance = Appearance.default
        self.fieldCard.tintColor = appearance.tintColor
        self.fieldCard.textColor = appearance.textColor
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return self.fieldCard.becomeFirstResponder()
    }
 
    private var internalInputChanged: InputChanged!
    var inputChanged: InputChanged {
        get {
            return internalInputChanged
        }set {
            internalInputChanged = newValue
        }
    }
    
}

extension CardInputNumberView: AKMaskFieldDelegate {

    func maskFieldDidBeginEditing(_ maskField: AKMaskField) {
        let isValid = maskField.isValid()
        self.internalInputChanged(InputType.cardNumber, InputEvent.beginEditing, self.rawValue(in: maskField), isValid)
    }
    
    func maskFieldDidEndEditing(_ maskField: AKMaskField) {
        let isValid = maskField.isValid()
        self.internalInputChanged(InputType.cardNumber, InputEvent.endEditing, self.rawValue(in: maskField), isValid)
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

        self.internalInputChanged(InputType.cardNumber, InputEvent.editingChanged, self.rawValue(in: maskField), isValid)
    }
}


fileprivate extension CardInputNumberView {
    func rawValue(in maskField: AKMaskField) -> String {
        
        guard let maskedText = maskField.text else {
            return ""
        }
        
        return maskedText.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "*", with: "")
    }
}
