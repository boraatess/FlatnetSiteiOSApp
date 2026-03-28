//
//  PollResultsVC.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 28.09.2025.
//

import Foundation
import UIKit
import SnapKit

class PollResultsVC: UIViewController {
    
    private let containerView = UIView()
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let questionLabel = UILabel()
    private let totalVotesLabel = UILabel()
    private let stackView = UIStackView()
    
    var questionText: String = ""
    var totalVotesText: String = ""
    var results: [(String, Double, Int)] = [] // (optionText, percentage, votes)
    
    var pollResult: PollResult?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // arka plan
    
        setupUI()
    }
    
    private func setupUI() {
        // Ana container (beyaz arkaplanlı popup)
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        // Header
        containerView.addSubview(headerView)
        headerView.backgroundColor = .systemBlue
        headerView.layer.cornerRadius = 12
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        titleLabel.text = "Anket Sonuçları"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        closeButton.setTitle("Kapat", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        headerView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        // Soru Label
        questionLabel.text = questionText
        questionLabel.font = .systemFont(ofSize: 14)
        questionLabel.numberOfLines = 0
        containerView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // Toplam oy label
        totalVotesLabel.text = totalVotesText
        totalVotesLabel.font = .systemFont(ofSize: 12)
        totalVotesLabel.textColor = .gray
        containerView.addSubview(totalVotesLabel)
        totalVotesLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // Sonuçlar StackView
        stackView.axis = .vertical
        stackView.spacing = 12
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(totalVotesLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // Her result için bar + label ekle
        for (optionText, percentage, votes) in results {
            let optionLabel = UILabel()
            optionLabel.text = "\(optionText) \(votes) Oy (\(Int(percentage))%)"
            optionLabel.font = .systemFont(ofSize: 13, weight: .medium)
            
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.progressTintColor = .systemBlue
            progressView.trackTintColor = .systemGray5
            progressView.setProgress(Float(percentage/100.0), animated: false)
            
            let vStack = UIStackView(arrangedSubviews: [optionLabel, progressView])
            vStack.axis = .vertical
            vStack.spacing = 4
            
            stackView.addArrangedSubview(vStack)
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
