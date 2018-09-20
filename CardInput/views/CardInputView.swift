//
//  CardInputView.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit
import AKMaskField


public enum InputEvent {
    case beginEditing
    case editingChanged
    case endEditing
}

public enum InputType: Int {
    case cardNumber = 0
    case cardHolder = 1
    case validThru = 2
    case cvv = 3
}

public struct CreditCard {
    
    public var number:String
    public var holder:String
    public var validThru:String
    public var cvv:String
    
    
    mutating func update(number:String){
        self.number = number
    }
    
    mutating func update(holder:String){
        self.holder = holder
    }
    
    mutating func update(validThru:String){
        self.validThru = validThru
    }
    
    mutating func update(cvv:String){
        self.cvv = cvv
    }
    
    
    init() {
        self.number = ""
        self.holder = ""
        self.validThru = ""
        self.cvv = ""
    }
}


public typealias InputChanged = (( _ type:InputType, _ event:InputEvent , _ input:String, _ isValid:Bool) -> ())
public typealias InputCompletion = (( _ creditCard:CreditCard) -> ())




protocol Validation {
    var inputChanged:InputChanged { get set }
}



/// --------------------------------------------------------------- ///
class ProcessButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.tintColor = UIColor.black
            }else{
                self.tintColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
            }
        }
    }
}
/// --------------------------------------------------------------- ///

final public class CardInputView: UIView {
    
    
    @IBOutlet weak var btnNext: ProcessButton!
    @IBOutlet weak var btnPrevious: ProcessButton!
    @IBOutlet weak var fieldCard: AKMaskField!
    @IBOutlet weak var fieldCvv: AKMaskField!
    @IBOutlet weak var fieldHolder: UITextField!
    @IBOutlet weak var fieldValidThru: UITextField!
    @IBOutlet weak var scrollView: CardInputScrollView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!

    fileprivate var showingBack:Bool = false
    
    private var creditCard:CreditCard
    
    private var state:InputType = .cardNumber { // The state of input.
        didSet {
            self.updateState()
        }
    }
    private var stateValidation:[InputType:Bool] = [InputType:Bool]()
    
    
    var didComplete: ((_ cardNumber:String, _ cardHolder:String, _ validThru:String) -> Void)?
    
    private var completion:InputCompletion?
    
    
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CardInputView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        creditCardView.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        stateValidation = [.cardNumber:false, .cardHolder:false, .validThru:false, .cvv:false]
        self.updateState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.creditCard = CreditCard()
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    init() {
        self.creditCard = CreditCard()
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.layoutSubviews()
    }
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return self.scrollView.becomeFirstResponder()
    }
    
    
    
    @IBAction func previousButtonTapped(){
        if !self.scrollView.canScroll(to: self.state.rawValue-1) {
            return
        }
        
        self.scrollView.scrollToPrevious()
        self.state = InputType.init(rawValue: self.state.rawValue-1)!
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if let _ = self.stateValidation[.cvv], (self.state == .validThru) {
            self.completion?(self.creditCard)
            return
        }
        
        if !self.scrollView.canScroll(to: self.state.rawValue+1) {
            return
        }
        
        self.scrollView.scrollToNext()
        self.state = InputType.init(rawValue: self.state.rawValue+1)!
    }
    
    private func updateState(){
        
        if let valid = self.stateValidation[self.state] {
            self.btnNext.isEnabled = valid
        }else{
            self.btnNext.isEnabled = false
        }
        
        switch self.state {
        case .cardNumber:
            self.btnPrevious.isHidden = true
            break
        case .cardHolder:
            self.btnPrevious.isHidden = false
            break
        case .validThru, .cvv:
            self.btnPrevious.isHidden = false
            if let valid1 = self.stateValidation[.validThru], let valid2 = self.stateValidation[.cvv] {
                self.btnNext.isEnabled = (valid1 && valid2)
            }else{
                self.btnNext.isEnabled = false
            }
            break
        }
    }
    
    private func flip() {
        var showingSide = frontView!
        var hiddenSide = backView!
        if showingBack {
            (showingSide, hiddenSide) = (backView, frontView)
        }
        
        UIView.transition(from:showingSide,
                          to: hiddenSide,
                          duration: 0.7,
                          options: [UIView.AnimationOptions.transitionFlipFromRight, UIView.AnimationOptions.showHideTransitionViews],
                          completion: nil)
    }
    
    
    
}



// MARK: - Observing
extension CardInputView {
    
    public func observeInputChanges(using closure: @escaping InputChanged) {
        self.scrollView.inputChanged = {[weak self] type, event, input, isValid in
            
            guard let strongSelf = self else { return }
            switch type {
            case .cardNumber:
                strongSelf.creditCard.update(number: input)
                strongSelf.fieldCard.text = input
                if isValid && event != .beginEditing && event != .endEditing {
                    strongSelf.nextButtonTapped(input)
                }
                break
            case .cardHolder:
                strongSelf.creditCard.update(holder: input)
                strongSelf.fieldHolder.text = input
                break
            case .validThru:
                strongSelf.creditCard.validThru = input
                strongSelf.fieldValidThru.text = input
                break
            case .cvv:
                if (event == .beginEditing && !strongSelf.showingBack) || (!isValid && !strongSelf.showingBack) {
                    strongSelf.flip()
                    strongSelf.showingBack = true
                }else if (event == .endEditing && strongSelf.showingBack) || (isValid && strongSelf.showingBack) {
                    strongSelf.flip()
                    strongSelf.showingBack = false
                }
                strongSelf.creditCard.update(cvv: input)
                strongSelf.fieldCvv.text = input
                break
            }
            
            strongSelf.stateValidation[type] = isValid
            strongSelf.updateState()
            closure(type, event, input, isValid)
        }
    }
    
    public func observeInputCompletion(with closure: @escaping InputCompletion) {
        self.completion = closure
    }
    
}

























/// --------------------------------------------------------------- ///
/// --------------------------------------------------------------- ///
/// --------------------------------------------------------------- ///
extension UIView {
    
    @discardableResult   // 1
    func fromNib<T : UIView>(name:String) -> T? {   // 2
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(name, owner: self, options: nil)?.first as? T else {    // 3
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        return contentView
    }
}


/// --------------------------------------------------------------- ///
/// --------------------------------------------------------------- ///
/// --------------------------------------------------------------- ///
extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
}

