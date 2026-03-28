//
//  PhoneTextfield.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 9.10.2025.
//

import Foundation
import UIKit

final class PhoneNumberTextField: UITextField, UITextFieldDelegate {
    
    /// Maksimum izin verilen hane sayısı (örnek: 10)
    var maxLength: Int = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        self.borderStyle = .roundedRect
        self.keyboardType = .numberPad
        self.placeholder = "(5xx) xxx xx xx"
    }
    
    // Sadece sayılara izin ver ve max uzunluk kontrolü
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Sadece rakam karakterlerine izin ver
        let allowed = CharacterSet.decimalDigits
        let set = CharacterSet(charactersIn: string)
        if !allowed.isSuperset(of: set) { return false }
        
        // Maksimum uzunluk kontrolü
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxLength
    }
    
    /// Backend'e gönderilmeden önce sadece rakamları döndür
    var cleanNumber: String {
        return (self.text ?? "").components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
