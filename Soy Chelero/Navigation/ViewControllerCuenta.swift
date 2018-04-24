//
//  ViewControllerCuenta.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/03/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerCuenta: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cerrarSesionTap(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBLogin") as UIViewController
        self.present(newViewController, animated: true) {
            UserDefaults.standard.set(false, forKey: "isLogged")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
