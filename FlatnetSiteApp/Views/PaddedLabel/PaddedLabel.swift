//
//  PaddedLabel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.10.2025.
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
