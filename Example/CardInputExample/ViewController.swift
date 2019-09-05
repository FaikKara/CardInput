//
//  ViewController.swift
//  CardInput
//
//  Created by Sem0043 on 9.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit
import CardInput

class NextButton: UIButton {
    
    override var isEnabled: Bool{
        didSet {
            if isEnabled {
                self.alpha = 1.0
            }else{
                self.alpha = 0.5
            }
        }
    }
    
}

class ViewController: UIViewController {
    @IBOutlet weak var btnNext: NextButton!
    @IBOutlet weak var cardInputView: CardInputView!
    private var creditCard: CreditCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardInputView.observeInputChanges { [weak self] (type, event, text, isValid, card) in
            guard let strongSelf = self else { return }
            strongSelf.creditCard = card
        }
        cardInputView.changeLabelsTextWithLocalizableText(holderName: "hold", validdThru: "th", cvv: "cv", cardNumber: "cn")
    }
    
    private func validate(card: CreditCard?) -> Bool {
        guard let card = card else { return false }
        return card.cvv.count > 0 && card.holder.count > 0 && card.number.count > 0 && card.validThru.count > 0
    }
    
    
    @IBAction func nextButtonTapped(_ sender: NextButton) {
        if !self.validate(card: self.creditCard){
            print("card is not valid")
        }else{
            print("card is valid")
        }
    }
    
    

}

