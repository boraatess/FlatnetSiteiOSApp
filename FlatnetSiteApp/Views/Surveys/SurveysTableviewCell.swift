//
//  SurveysTableviewCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 17.09.2025.
//

import Foundation
import UIKit
import SnapKit

protocol SurveysTableviewCellDelegate: AnyObject {
    func didSelectOption(id: Int)
}

class SurveysTableviewCell: UITableViewCell {
    
    static let identifier = "SurveysTableviewCell"

    let radioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        
        button.isUserInteractionEnabled = false // cell tıklanınca seçilsin
        return button
    }()
    
    private let customRadio: CustomRadioButton = {
        let button = CustomRadioButton()
        button.selectedFillColor = .systemBlue
        button.selectedBorderColor = .systemBlue
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let titleLaBabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        
        return label
    }()
    
    private var optionID: Int?
    weak var delegate: SurveysTableviewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    func configure(with option: Option, and isSelected: Bool) {
        titleLaBabel.text = option.text
        self.optionID = option.id
        customRadio.isSelected = isSelected
        
    }
    
    private func setupLayout() {
        
        
        stackView.addArrangedSubview(customRadio)
        stackView.addArrangedSubview(titleLaBabel)
        
        customRadio.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            
        }
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            
        }
        
        
    }
    
    func notifySelection() {
        if let id = optionID {
            delegate?.didSelectOption(id: id)
        }
        
    }
    
}
