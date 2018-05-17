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
    var unoChelaDosCoaster = 0
    var hash = ""
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        let regex1 = "socios.soychelero.mx/#/index/coleccion"
        let regex2 = "socios.soychelero.mx/#/index/coasters/"
        if(code.count>45){
            let index = code.index(code.startIndex, offsetBy: 38)
            let mySubstring = String(code[..<index])
            print(mySubstring)
            if(mySubstring == regex1){
                unoChelaDosCoaster = 1
                let arr = code.split(separator: "/")
                hash = String(arr[arr.count-1])
                controller.dismiss(animated: true, completion: nil)
            }else if mySubstring == regex2{
                unoChelaDosCoaster = 2
                let arr = code.split(separator: "/")
                hash = String(arr[arr.count-1])
                controller.dismiss(animated: true, completion: nil)
            }else{
                controller.dismiss(animated: true, completion: nil)
                print(code)
            }
        }else{
            controller.dismiss(animated: true, completion: nil)
            print(code)
        }
        
    }
        
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        print("Se cerro")
        controller.dismiss(animated: true, completion: nil)
        if(unoChelaDosCoaster == 1){
            callChelaService()
        }else if(unoChelaDosCoaster == 2){
            callCoasterService()
        }else{
            
        }
    }
    
    func callChelaService(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "http://138.197.195.16/getCerveza/?hash=\(self.hash)"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "GET"
            
            let g = Globales()
            g.printWSLog(req: req)
            URLSession.shared.dataTask(with: req, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        DispatchQueue.main.async {
                            print(json!)
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }

    func callCoasterService(){
        
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
