//
//  TabBarControllerPrincipal.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/03/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TabBarControllerPrincipal: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        self.delegate = self
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        super.viewDidLoad()
        self.viewControllers![2].tabBarItem.image = #imageLiteral(resourceName: "qrOriginial")
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.title == "QR"{
            //tabBarController.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuSB") as! ViewControllerMenu, animated: true)
            
            tabBarController.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scannerQRSB") as! ViewControllerForScanner, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
