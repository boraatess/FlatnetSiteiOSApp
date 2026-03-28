//
//  PasswordTextfield.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 7.10.2025.
//

import Foundation
import UIKit

class PasswordTextField: UITextField {

    private var toggleButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isSecureTextEntry = true
        borderStyle = .roundedRect
        autocapitalizationType = .none
        autocorrectionType = .no

        // Toggle button
        toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)

        rightView = toggleButton
        rightViewMode = .always
    }

    @objc private func togglePasswordView() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)

        // iOS bugfix: imleç kaymasını engellemek için text’i tekrar ata
        if let text = self.text, isSecureTextEntry {
            self.text = ""
            self.insertText(text)
        }
    }
}
