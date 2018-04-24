//
//  ViewControllerPrivacidad.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 02/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerPrivacidad: UIViewController {
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var siBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noBtn.layer.borderWidth = 2
        noBtn.layer.borderColor = UIColor().hexStringToUIColor(hex: "C4895A").cgColor
        
        siBtn.layer.borderWidth = 2
        siBtn.layer.borderColor = UIColor().hexStringToUIColor(hex: "C4895A").cgColor
        // Do any additional setup after loading the view.
    }
    @IBAction func siAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isMayorEdad")
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func noAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isMayorEdad")
        if let url = URL(string: "https://www.youtube.com/watch?v=k7exgdlVyU0"){
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func politicaAction(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
