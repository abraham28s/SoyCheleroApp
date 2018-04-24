//
//  ViewControllerMiColeccion.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 18/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit
import SDWebImage

class ViewControllerMiColeccion: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chelas:[[String:String]] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chelas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chela") as! TableViewCellChelas
        cell.nombreLbl.text = chelas[indexPath.row]["nombre"]
        cell.imageImg.contentMode = .scaleAspectFit
        let urlString = "https://socios.soychelero.mx/img/tarjetas/\(String(describing: chelas[indexPath.row]["imagen"]!))"
        let urlImg = URL(string: urlString)
        print(urlImg!)
        cell.imageImg.sd_setImage(with: urlImg, placeholderImage: UIImage.gifImageWithName("loader"))
        cell.ratingBar.rating = Double(chelas[indexPath.row]["valoracion"]!)!
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedCell)))
        return cell
    }
    
    @objc
    func tappedCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        print("SELECTTTT")
        // assign page view content loader
        let fBSignRegisterViewController = storyboard.instantiateViewController(withIdentifier: "chelaDetailSB")
            as? ViewControllerForChela;
        
        
        
        fBSignRegisterViewController?.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.present(fBSignRegisterViewController!, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabla.separatorStyle = .none
        tabla.delegate = self
        tabla.dataSource = self
        tabla.tableFooterView = UIView()
        tabla.register(UINib(nibName: "TableViewCellChelas", bundle: nil), forCellReuseIdentifier: "chela")
        let vista = UIView(frame: self.view.frame)
        vista.backgroundColor = UIColor().hexStringToUIColor(hex: "474749")
        tabla.isUserInteractionEnabled = true
        tabla.backgroundView = vista
        
        
        consumeWebServices()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func consumeWebServices(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "https://socios.soychelero.mx/back/cervezas.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=traerColeccion&usuario={\"idUsuario\":\"\(String(describing: idUser!))\"}"
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
                            self.parsea(json: json!)
                            self.tabla.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func parsea(json: NSDictionary){
        let root = json.value(forKey: "root") as! NSArray
        for chela in root{
            let chelaDic = chela as! NSDictionary
            var nuevaChela:[String:String] = [:]
            nuevaChela["idCerveza"] = chelaDic.value(forKey: "idCerveza") as! String
            nuevaChela["imagen"] = chelaDic.value(forKey: "imagen") as! String
            nuevaChela["nombre"] = chelaDic.value(forKey: "nombre") as! String
            nuevaChela["valoracion"] = chelaDic.value(forKey: "valoracion") as! String
            chelas.append(nuevaChela)
        }
    }

}
