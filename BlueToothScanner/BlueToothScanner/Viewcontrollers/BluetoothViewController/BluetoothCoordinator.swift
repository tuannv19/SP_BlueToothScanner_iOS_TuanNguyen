//
//  BluetoothCoordinator.swift
//  BlueToothScanner
//
//  Created by tuan.nguyenv on 7/30/20.
//  Copyright © 2020 tuannv19. All rights reserved.
//

import UIKit


class BluetoothCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    enum Router{
        case initial
    }
    
    func routed(router: Router) {
        switch router {
        case .initial:
            let vc = BluetoothViewController.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
