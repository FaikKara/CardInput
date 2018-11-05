//
//  CardInputScrollView.swift
//  CardInput
//
//  Created by Sem0043 on 18.09.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit

/**
 
 CardInputScrollView
 
 The `UIScrollView` subclass.
 It enables to enter credit card inputs such as **card number**, **card holder**, **valid thru**, and **cvv**.
 By Default horizontal & vertical scrolling is disabled, the parentView `CardInputView` is responsible on where to scroll or when to scroll.
 
 
 */

internal class CardInputScrollView: UIScrollView, Validation {

    private var internalInputChanged: InputChanged!
    var inputChanged: InputChanged {
        get {
            return internalInputChanged
        }set {
            internalInputChanged = newValue
        }
    }
    
    
    private var cardNumber:CardInputNumberView!
    private var cardHolder:CardInputHolderView!
    private var cardValidThru:CardInputValidThruView!
    private var currentIndex:Int = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cardNumber = CardInputNumberView()
        cardHolder = CardInputHolderView()
        cardValidThru = CardInputValidThruView()
        
        self.addSubview(cardNumber)
        self.addSubview(cardHolder)
        self.addSubview(cardValidThru)
        
        self.isPagingEnabled = true
        self.isScrollEnabled = false
        self.clipsToBounds = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.cardNumber.inputChanged = { type, event, rawText, isValid, card in
            self.internalInputChanged(type, event, rawText, isValid, card)
        }
        
        self.cardHolder.inputChanged = { type, event, rawText, isValid, card in
            self.internalInputChanged(type, event, rawText, isValid, card)
        }
        
        self.cardValidThru.inputChanged = { type, event, rawText, isValid, card in
            self.internalInputChanged(type, event, rawText, isValid,card)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var index = 0
        let width = self.frame.width
        let heigt = self.frame.height
        for view in self.subviews {
            let xOffset = CGFloat(index) * width
            view.frame = CGRect.init(x: xOffset, y: 0, width: width, height: heigt)
            index = index + 1
        }
        
        self.contentSize = CGSize.init(width: width*CGFloat(3), height: heigt)
    }

    override func becomeFirstResponder() -> Bool {
        self.findNextResponder(for: InputType(rawValue: self.currentIndex)!)
        return super.becomeFirstResponder()
    }
    
}



// MARK: - Scroll Extension
extension CardInputScrollView {
    
    /**
      Scrolls to given index if index is in the range, do nothing otherwise.
     - Parameters:
        - index: The index to be scrolled
        - animated: Animation flag
     */
    @discardableResult
    func scrollToIndex(index:Int, animated:Bool) -> Bool{
        
        if !self.canScroll(to: index) { return false}
        
        let width = self.bounds.width
        let offset = width * CGFloat(index)
        self.setContentOffset(CGPoint.init(x: offset, y: self.contentOffset.y), animated: animated)
        self.currentIndex = index
        self.findNextResponder(for: InputType(rawValue: self.currentIndex)!)
        return true
    }
    
    /// Scrolls to next index if possible, do nothing otherwise
    func scrollToNext(){
        let newIndex = self.currentIndex + 1
        self.scrollToIndex(index: newIndex, animated: true)
    }
    
    /// Scrolls to previous index if possible, do nothing otherwise
    func scrollToPrevious(){
        let newIndex = self.currentIndex-1
        self.scrollToIndex(index: newIndex, animated: true)
    }
    
    /**
     Returns whether `UIScrollView` can scroll to given `index` or not.
     - Parameters:
        - index: The index to scroll
    */
    func canScroll(to index:Int) -> Bool{
        return index >= 0 && index < self.subviews.count
    }
    
    
    
    
    internal func findNextResponder(for state:InputType) {
        switch state {
        case InputType.cardNumber:
            self.cardNumber.becomeFirstResponder()
            break
        case InputType.cardHolder:
            self.cardHolder.becomeFirstResponder()
            break
        case InputType.validThru,InputType.cvv:
            self.cardValidThru.becomeFirstResponder()
            break
        }
    }
}
