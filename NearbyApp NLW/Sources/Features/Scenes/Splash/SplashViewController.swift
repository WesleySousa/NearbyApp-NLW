//
//  SplashViewController.swift
//  NearbyApp NLW
//
//  Created by Wesley Silva on 12/12/24.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    let contentView: SplashView
    weak var delagate: SplashFlowDelagate?
    
    init(contentView: SplashView,
         delegate: SplashFlowDelagate) {
        self.contentView = contentView
        self.delagate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        decideFlow()
    }
    
    private func setUp() {
        self.view.addSubview(contentView)
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Colors.greenLight
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        self.setupContentViewToViewController(contentView: contentView)
    }
    
    private func decideFlow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [ weak self ] in
            self?.delagate?.decideNavigationFlow()
        }
    }
    
}
