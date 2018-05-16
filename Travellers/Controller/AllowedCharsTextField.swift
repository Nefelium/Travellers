//
//  AllowedCharsTextField.swift
//  Travellers
//
//  Created by admin on 11.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

// ограничение диапазона символов для поля количества
class AllowedCharsTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var allowedChars: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return allowedIntoTextField(text: prospectiveText)
    }
    
    func allowedIntoTextField(text: String) -> Bool {
        return text.containsOnlyCharactersIn(matchCharacters: allowedChars)
    }
}

private extension String {
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
}
