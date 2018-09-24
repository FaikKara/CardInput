//
//  CardInputHolderView.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit

/// The UIView that gets Credit Card Holder Name. 
internal class CardInputHolderView: UIView, Validation {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var fieldHolder: UITextField!
    
    private func commonInit(){
        
        if let bundle = Bundle.cardInputBundle() {
            bundle.loadNibNamed("CardInputHolderView", owner: self, options: nil)
            addSubview(contentView)
        }
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.lblTitle.text = "CARD HOLDER"
        self.fieldHolder.delegate = self
        self.fieldHolder.autocorrectionType = .no
        
        let appearance = Appearance.default
        self.fieldHolder.tintColor = appearance.tintColor
        self.fieldHolder.textColor = appearance.textColor
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
    
}

extension CardInputHolderView : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isValid = ((textField.text?.count ?? 0) + string.count) > 0
        let rawText = "\(textField.text ?? "")\(string)"
        self.internalChanged(InputType.cardHolder, InputEvent.editingChanged, rawText, isValid)
        return true
    }

}

