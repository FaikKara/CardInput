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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardInputView.observeInputChanges { (type, event, text, isValid) in
            
        }
        
        cardInputView.observeInputCompletion { (card) in
            
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if "embedCardInput" == segue.identifier {
//            let dest = segue.destination as! CardInputController
//            dest.appearance = Appearance.init(tintColor: UIColor.purple, textColor: UIColor.green)
//        }
   
    }
    
    
    
    

}

