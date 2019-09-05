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


public typealias InputChanged = (( _ type: InputType, _ event: InputEvent , _ input: String, _ isValid: Bool, _ creditCard: CreditCard?) -> ())

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
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var brandImageViewBack: UIImageView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var btnNext: ProcessButton!
    @IBOutlet weak var btnPrevious: ProcessButton!
    @IBOutlet weak var fieldCard: AKMaskField!
    @IBOutlet weak var fieldCvv: UITextField!
    @IBOutlet weak var fieldHolder: UITextField!
    @IBOutlet weak var fieldValidThru: UITextField!
    @IBOutlet weak var scrollView: CardInputScrollView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblHolderName: CardLabel!
    @IBOutlet weak var lblValidThru: CardLabel!    
    fileprivate var showingBack:Bool = false
    private var creditCard:CreditCard
    
    private var state:InputType = .cardNumber { // The state of input.
        didSet {
            self.updateState()
        }
    }
    private var stateValidation:[InputType:Bool] = [InputType:Bool]()
    
    
    private func commonInit(){
        
        if let bundle = Bundle.cardInputBundle() {
            UIFont.registerDefaultFont(in: bundle)
            bundle.loadNibNamed("CardInputView", owner: self, options: nil)
            addSubview(contentView)
            
            self.btnNext.setImage(UIImage.init(named: "arrow_right.png", in: bundle, compatibleWith: nil), for: .normal)
            self.btnPrevious.setImage(UIImage.init(named: "arrow_left.png", in: bundle, compatibleWith: nil), for: .normal)
            self.backImageView.image = UIImage.init(named: "credit_card_back.png", in: bundle, compatibleWith: nil)
            self.frontImageView.image = UIImage.init(named: "credit_card_front.png", in: bundle, compatibleWith: nil)
        }
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        creditCardView.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        stateValidation = [.cardNumber:false, .cardHolder:false, .validThru:false, .cvv:false]
        self.updateState()
        self.fieldCard.textColor = UIColor.white.withAlphaComponent(0.3)
        self.fieldValidThru.textColor = UIColor.white.withAlphaComponent(0.3)
        self.fieldHolder.textColor = UIColor.white.withAlphaComponent(0.3)
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
    
    public func changeLabelsTextWithLocalizableText(holderName: String? = "HOLDER NAME", validdThru: String? = "VALID THRU", cvv: String? = "CVV",  cardNumber: String? = "CARD NUMBER") {
        self.lblHolderName.text = holderName
        self.lblValidThru.text = validdThru
        self.scrollView.cardHolder.localizedText(holderName: holderName)
        self.scrollView.cardValidThru.localizedText(validThru: validdThru, cvv: cvv)
        self.scrollView.cardNumber.localizedText(cardNumber: cardNumber)
    }
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return self.scrollView.becomeFirstResponder()
    }
    
    
    
    @IBAction private func previousButtonTapped(){
        if !self.scrollView.canScroll(to: self.state.rawValue-1) {
            return
        }
        
        self.scrollView.scrollToPrevious()
        self.state = InputType.init(rawValue: self.state.rawValue-1)!
    }
    
    @IBAction private  func nextButtonTapped(_ sender: Any) {

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
        
        self.btnNext.isHidden = false
        switch self.state {
        case .cardNumber:
            self.btnPrevious.isHidden = true
            break
        case .cardHolder:
            self.btnPrevious.isHidden = false
            break
        case .validThru, .cvv:
            self.btnPrevious.isHidden = false
            self.btnNext.isHidden = true
            if let valid1 = self.stateValidation[.validThru], let valid2 = self.stateValidation[.cvv] {
                if valid1 && valid2 {
                    self.endEditing(true)
                }
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
    
    
    @IBAction private func cardNumberTapped(_ sender: UIButton) {
        self.scrollView.scrollToIndex(index: InputType.cardNumber.rawValue, animated: true)
        self.state = .cardNumber
    }
    
    @IBAction private func cardHolderTapped(_ sender: UIButton) {
        self.scrollView.scrollToIndex(index: InputType.cardHolder.rawValue, animated: true)
        self.state = .cardHolder
    }
    
    @IBAction private func validThruTapped(_ sender: UIButton) {
        self.scrollView.scrollToIndex(index: InputType.validThru.rawValue, animated: true)
        self.state = .validThru
    }
    
    
}



// MARK: - Observing
extension CardInputView {
    public func observeInputChanges(using closure: @escaping InputChanged) {
        self.scrollView.inputChanged = {[weak self] type, event, input, isValid, card in
            
            
            var needsStateUpdate = true
            
            guard let strongSelf = self else { return }
            switch type {
            case .cardNumber:
                strongSelf.creditCard.update(number: input)
                strongSelf.fieldCard.text = input
                strongSelf.fieldCard.textColor = self?.textColor(for: input)
                if isValid && event != .beginEditing && event != .endEditing && input.count == CardNumber.max_length{
                    strongSelf.nextButtonTapped(input)
                }
                strongSelf.applyCardBrand(to: input)
                break
            case .cardHolder:
                strongSelf.creditCard.update(holder: input)
                strongSelf.fieldHolder.text = input
                strongSelf.fieldHolder.textColor = self?.textColor(for: input)
                if event == .endEditing {
                    strongSelf.nextButtonTapped(input)
                }
                break
            case .validThru:
                strongSelf.creditCard.validThru = input
                strongSelf.fieldValidThru.text = input
                strongSelf.fieldValidThru.textColor = self?.textColor(for: input)
                if event == .beginEditing  {
                    needsStateUpdate = false
                }
                break
            case .cvv:
                if (event == .beginEditing && !strongSelf.showingBack) || (!isValid && !strongSelf.showingBack) {
                    strongSelf.flip()
                    strongSelf.showingBack = true
                    needsStateUpdate = false
                }else if (event == .endEditing && strongSelf.showingBack) || (isValid && strongSelf.showingBack) {
                    strongSelf.flip()
                    strongSelf.showingBack = false
                }
                strongSelf.creditCard.update(cvv: input)
                strongSelf.fieldCvv.text = input
                break
            }
            
            strongSelf.stateValidation[type] = isValid
            if needsStateUpdate {
                strongSelf.updateState()
            }
            closure(type, event, input, isValid, strongSelf.creditCard)
        }
    }
    
    private func textColor(for input:String) -> UIColor {
        if input.count > 0 {
            return UIColor.white
        }else{
            return UIColor.white.withAlphaComponent(0.3)
        }
    }
    
    private func applyCardBrand(to input:String){
        let state = CardState.init(fromPrefix: input)
        let image = self.cardImage(forState: state)
        self.brandImageView.image = image
        self.brandImageViewBack.image = image
    }
    
    private func cardImage(forState cardState:CardState) -> UIImage? {
        switch cardState {
        case .identified(let cardType):
            switch cardType{
            case .visa:         return UIImage.image(namedInBundle: "visa")
            case .masterCard:   return UIImage.image(namedInBundle: "mastercard")
            case .amex:         return UIImage.image(namedInBundle: "amex")
            case .maestro:       return UIImage.image(namedInBundle: "maestro")
            default:
                return nil
            }
        case .indeterminate: return nil
        case .invalid:      return nil
        }
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



class CardLabel: UILabel {
    
    private static let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.kern:0.74,
                                                                  NSAttributedString.Key.font:UIFont(name: "Avenir-Medium", size: 9.5)!,
                                                                  NSAttributedString.Key.foregroundColor:UIColor(hex: "B6CFEE")]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureText()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureText()
    }
    
    override var text: String? {
        didSet {
            self.configureText()
        }
    }
    
    private func configureText(){
        guard let value = self.text else { return }
        self.attributedText = NSAttributedString.init(string: value, attributes: CardLabel.attributes)
    }
    
    
}







extension UIImage {
    convenience init?(namedInBundle name:String){
        self.init(named: name, in: Bundle.cardInputBundle(), compatibleWith: nil)
    }
    
    class func image(namedInBundle name:String, renderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysOriginal) -> UIImage? {
        if let image = UIImage.init(namedInBundle: name) {
            return image.withRenderingMode(renderingMode)
        }
        return nil
    }
}

extension UIColor {
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init()
        }else{
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
        }
    }
}
