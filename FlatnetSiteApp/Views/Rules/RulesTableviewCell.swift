//
//  RulesTableviewCell.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 16.09.2025.
//

import Foundation
import UIKit
import WebKit
import SnapKit

class RulesTableviewCell: UITableViewCell, WKNavigationDelegate {
    
    static let identifier = "RulesTableviewCell"
       
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false  // İçeriğe göre büyüsün
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0 // Çok satırlı
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
       
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.scrollView.isScrollEnabled = false // TableView içinde scroll olmasın
        return wv
    }()
    
    var onHeightChange: (() -> Void)?

    var heightConstraint: NSLayoutConstraint?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(textView)
                
                
        NSLayoutConstraint.activate([
                    textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                    textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                    textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
                
        ])
       
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    func setHtml(_ html: String) {
        let htmlWithStyle = """
        <html>
        <head>
        <meta charset="UTF-8">
        <style>
        body {
            font-family: -apple-system, Helvetica, Arial, sans-serif;
            font-size: 18px;
        }
        h4 { font-size: 20px; }
        h5 { font-size: 16px; }
        p { font-size: 14px; }
        li { font-size: 14px; }
        </style>
        </head>
        <body>
        \(html)
        </body>
        </html>
        """
        
        guard let data = htmlWithStyle.data(using: .utf8) else { return }
        textView.attributedText = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    
    func layout() {
        contentView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        
    }
    
    func loadHTML(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // İçerik yüklenince yüksekliği ölçelim
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] result, error in
            guard let self = self, let height = result as? CGFloat, error == nil else { return }
            if abs(self.webView.frame.height - height) > 1 {
                self.webView.heightAnchor.constraint(equalToConstant: height).isActive = true
                self.onHeightChange?()
            }
            // TableView’i yeniden yükleyerek hücre boyutunu güncelle
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
                
            }
            
        }
        
    }
    
}
