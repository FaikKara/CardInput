//
//  CardInputController.swift
//  CardInput
//
//  Created by Sem0043 on 18.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit

class CardInputController: UIViewController {

    @IBOutlet weak var cardInputView: CardInputView!
    
    var appearance:Appearance? {
        didSet {
            guard let appearance = self.appearance else { return }
            Appearance.default = appearance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardInputView.observeInputChanges { (type, event, input, isValid) in
            print("row text \(input) -- for type \(type) validation status:\(isValid)")
        }
        
        self.cardInputView.observeInputCompletion { (card:CreditCard) in
            print("card number...\(card.number)")
            print("card holder...\(card.holder)")
            print("card valid thru...\(card.validThru)")
            print("card cvv...\(card.cvv)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cardInputView.becomeFirstResponder()
    }
}
