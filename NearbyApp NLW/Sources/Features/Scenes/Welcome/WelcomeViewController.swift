//
//  WelcomeViewController.swift
//  NearbyApp NLW
//
//  Created by Wesley Silva on 15/12/24.
//

import Foundation
import UIKit

public class WelcomeViewController: UIViewController {
    let contentView: WelcomeView
    weak var flowDelegate: WelcomeFlowDelegate?
    
    init(contentView: WelcomeView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        
        contentView.didTapButton = { [weak self] in
            self?.flowDelegate?.goToHome()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        self.view.addSubview(contentView)
        self.view.backgroundColor = .secondarySystemBackground
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        self.setupContentViewToViewController(contentView: contentView)
    }
    
    
}
