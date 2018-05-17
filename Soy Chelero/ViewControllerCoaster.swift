//
//  ViewControllerCoaster.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 16/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerCoaster: UIViewController {
    @IBOutlet weak var imagen: UIImageView!
    var imagenStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlString = self.imagenStr
        let urlImg = URL(string: urlString)
        imagen.sd_setImage(with: urlImg)
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
