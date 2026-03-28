//
//  BaseViewModel.swift
//  FlatnetSiteApp
//
//  Created by bora ateş on 5.09.2025.
//

import Foundation

protocol ViewModelOutputProtocol: AnyObject {}

protocol ViewModelProtocol: AnyObject {
    associatedtype T
    var outputDelegate: T? { get set }
    func viewDidAppear()
}

extension ViewModelProtocol {
    func viewDidAppear() {}
}
