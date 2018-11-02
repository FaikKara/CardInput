//
//  CardParser.swift
//
//  Created by Jason Clark on 6/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

//MARK: - CardType

public enum CardType {
    case amex
    case diners
    case discover
    case jcb
    case masterCard
    case maestro
    case visa

    static let allValues: [CardType] = [.visa, .masterCard, .maestro,.amex, .diners, .discover, .jcb]

    private var validationRequirements: ValidationRequirement {
        let prefix: [PrefixContainable], length: [Int]

        switch self {
        /* // IIN prefixes and length requriements retreived from https://en.wikipedia.org/wiki/Bank_card_number on June 28, 2016 */

        case .amex:         prefix = ["34", "37"]
                            length = [15]

        case .diners:       prefix = ["300"..."305", "309", "36", "38"..."39"]
                            length = [14]

        case .discover:     prefix = ["6011", "65", "644"..."649", "622126"..."622925"]
                            length = [16]

        case .jcb:          prefix = ["3528"..."3589"]
                            length = [16]

        case .masterCard:   prefix = ["51"..."55", "2221"..."2720"]
                            length = [16]
            
        // https://www.mastercard.us/content/dam/mccom/global/documents/mastercard-rules.pdf
        // For a Maestro Account, the PAN must be 13 to 19 digits in length. A
        case .maestro:      prefix = ["5018", "5020", "5038", "5612", "5893", "6304", "6759", "6761", "6762", "6763", "0604", "6390"]
                            length = [13, 14, 15, 16, 17, 18, 19]
            
        case .visa:         prefix = ["4"]
                            length = [13, 16, 19]
        
            

        }

        return ValidationRequirement(prefixes: prefix, lengths: length)
    }

    var segmentGroupings: [Int] {
        switch self {
        case .amex:      return [4, 6, 5]
        case .diners:    return [4, 6, 4]
        default:         return [4, 4, 4, 4]
        }
    }

    var maxLength: Int {
        return validationRequirements.lengths.max() ?? 16
    }

    var cvvLength: Int {
        switch self {
        case .amex: return 4
        default: return 3
        }
    }

    func isValid(_ accountNumber: String) -> Bool {
        return validationRequirements.isValid(accountNumber) && CardType.luhnCheck(accountNumber)
    }

    func isPrefixValid(_ accountNumber: String) -> Bool {
        return validationRequirements.isPrefixValid(accountNumber)
    }

}

fileprivate extension CardType {

    struct ValidationRequirement {
        let prefixes: [PrefixContainable]
        let lengths: [Int]

        func isValid(_ accountNumber: String) -> Bool {
            return isLengthValid(accountNumber) && isPrefixValid(accountNumber)
        }

        func isPrefixValid(_ accountNumber: String) -> Bool {
            guard prefixes.count > 0 else { return true }
            return prefixes.contains { $0.hasCommonPrefix(with: accountNumber) }
        }

        func isLengthValid(_ accountNumber: String) -> Bool {
            guard lengths.count > 0 else { return true }
            return lengths.contains { accountNumber.length == $0 }
        }
    }

    // from: https://gist.github.com/cwagdev/635ce973e8e86da0403a
    static func luhnCheck(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }

}

//MARK: - CardState

public enum CardState {
    case identified(CardType)
    case indeterminate([CardType])
    case invalid
}

extension CardState: Equatable {}
public func ==(lhs: CardState, rhs: CardState) -> Bool {
    switch (lhs, rhs) {
    case (.invalid, .invalid): return true
    case (let .indeterminate(cards1), let .indeterminate(cards2)): return cards1 == cards2
    case (let .identified(card1), let .identified(card2)): return card1 == card2
    default: return false
    }
}

extension CardState {

    public init(fromNumber number: String) {
        if let card = CardType.allValues.first(where: { $0.isValid(number) }) {
            self = .identified(card)
        }
        else {
            self = .invalid
        }
    }

    public init(fromPrefix prefix: String) {
        let possibleTypes = CardType.allValues.filter { $0.isPrefixValid(prefix) }
        if possibleTypes.count >= 2 {
            self = .indeterminate(possibleTypes)
        }
        else if possibleTypes.count == 1, let card = possibleTypes.first {
            self = .identified(card)
        }
        else {
            self = .invalid
        }
    }

}

//MARK: - PrefixContainable

fileprivate protocol PrefixContainable {

    func hasCommonPrefix(with text: String) -> Bool

}

extension ClosedRange: PrefixContainable {

    func hasCommonPrefix(with text: String) -> Bool {
        //cannot include Where clause in protocol conformance, so have to ensure Bound == String :(
        guard let lower = lowerBound as? String, let upper = upperBound as? String else { return false }

        let trimmedRange: ClosedRange<String> = {
            let length = text.length
            let trimmedStart = String(lower.prefix(length))
            let trimmedEnd = String(upper.prefix(length))
            return trimmedStart...trimmedEnd
        }()
        

        let trimmedText = String(text.prefix(trimmedRange.lowerBound.count))
        return trimmedRange ~= trimmedText
    }

}

extension String: PrefixContainable {

    func hasCommonPrefix(with text: String) -> Bool {
        return hasPrefix(text) || text.hasPrefix(self)
    }

}

fileprivate extension String {
    var length: Int {
        return self.count
    }

}
