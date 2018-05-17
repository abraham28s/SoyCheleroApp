//
//  ViewControllerCoasters.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 03/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerCoasters: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    @IBOutlet weak var numPort: UILabel!
    @IBOutlet weak var collectionCoasters: UICollectionView!
    var coasterArr:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...20{
            coasterArr.append(["idCoaster":"Vacio","imagen":"../portavaso-sin.png"])
        }
        
        collectionCoasters.delegate = self
        collectionCoasters.dataSource = self
        collectionCoasters.register(UINib(nibName: "CollectionViewCellCoaster", bundle: nil), forCellWithReuseIdentifier: "ccell1")
        
        
        let vista = UIView(frame: self.view.frame)
        vista.backgroundColor = UIColor().hexStringToUIColor(hex: "474749")
        
        collectionCoasters.backgroundView = vista
        
        
        
       
        consumeWebServices()
        // Do any additional setup after loading the view.
    }
    
    
    func consumeWebServices(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "https://socios.soychelero.mx/back/coasters.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=traerCoasters&idUsuario=\(String(describing: idUser!))"
            print(postString)
            req.httpBody = postString.data(using: .utf8)
            
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
                            let success = json?.value(forKey: "success") as! Bool
                            let records = json?.value(forKey: "records") as! Int
                            self.numPort.text = String(format: "%02d", records)
                            if(success){
                                if(records > 0){
                                    let root = json?.value(forKey: "root") as! NSArray
                                    for coa in root{
                                        let coaster = coa as! NSDictionary
                                        let nuevoDictionary:[String:String] = ["idCoaster":coaster.value(forKey: "idCoaster") as! String,"imagen":coaster.value(forKey: "imagen") as! String]
                                        self.coasterArr.insert(nuevoDictionary, at: 0)
                                        self.coasterArr.remove(at: self.coasterArr.count-1)
                                        
                                    }
                                    self.collectionCoasters.reloadData()
                                    //print(self.coasterArr)
                                }else{
                                    print("No hay coasters")
                                }
                            }else{
                                let messageText = json?.value(forKey: "messageText") as! String
                                let alerta = UIAlertController(title: "Error", message: messageText, preferredStyle: .alert)
                                let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                alerta.addAction(accion)
                                self.present(alerta, animated: true, completion: nil)
                            }
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 20
        
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = itemWidth//(collectionView.bounds.height / 2) - hardCodedPadding
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coasterArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell1", for: indexPath) as! CollectionViewCellCoaster;
        let urlString = "https://socios.soychelero.mx/img/coasters/\(String(describing: coasterArr[indexPath.row]["imagen"]!))"
        let urlImg = URL(string: urlString)
        //print(urlImg!)
        //print("test col")
        cell.imagenCoaster.sd_setImage(with: urlImg, completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(coasterArr[indexPath.row]["imagen"]! != "../portavaso-sin.png"){
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "coasterSB") as! ViewControllerCoaster
            newViewController.imagenStr = "https://socios.soychelero.mx/img/coasters/\(String(describing: coasterArr[indexPath.row]["imagen"]!))"
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
    
}
