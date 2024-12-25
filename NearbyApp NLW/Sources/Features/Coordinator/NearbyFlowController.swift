//
//  NearbyFlowController.swift
//  NearbyApp NLW
//
//  Created by Wesley Silva on 12/12/24.
//

import Foundation
import UIKit

class NearbyFlowController {
    private var navigationController: UINavigationController?
    
    public init() {
    }
    
    func start() -> UINavigationController? {
//        let contentView = SplashView()
        /*let startViewController = SplashViewController(contentView: contentView, delegate:  self)*/
        let startViewController = DetailsViewController()
        self.navigationController = UINavigationController(rootViewController: startViewController );
        return self.navigationController;
    }
}


extension NearbyFlowController: SplashFlowDelagate {
    func decideNavigationFlow() {
        let contentView = WelcomeView()
        let welcomeViewController = WelcomeViewController(contentView: contentView)
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
}
