//
//  ShowDocumentVC.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 18.09.2025.
//

import UIKit
import WebKit
import SnapKit


class ShowDocumentVC: UIViewController {
    
    private let header = HeaderView(
           icon: UIImage(named: "documentSearch"),
           title: "Belge Görüntüle",
           subtitle: ""
       )
    
    private var wkwebView: WKWebView = {
        let webview = WKWebView()
        
        return webview
    }()
    
    private let docImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    var invoiceUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadWebView()
        
    }
    
    func loadWebView() {
        
        if let urlstring = invoiceUrl, let url = URL(string: urlstring ) {
            
            let request = URLRequest(url: url )
            wkwebView.load(request)
            
        }
        
    }
    
    func downloadImage() {
        
        if let urlString = invoiceUrl, let url = URL(string: urlString) {
            
            docImageView.load(from: url)
            
        }
        
    }
    
}

extension ShowDocumentVC {
    
    func setupLayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(header)
              
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
      
        view.addSubview(wkwebView)
        wkwebView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
                
    }
    
}
