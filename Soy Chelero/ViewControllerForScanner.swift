//
//  ViewControllerForScanner.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 18/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit
import BarcodeScanner

class ViewControllerForScanner: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    let viewController = BarcodeScannerViewController()
    var scanner = true
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        print("Se cerro")
        controller.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if scanner{
            present(viewController, animated: true, completion: nil)
            scanner = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
