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
    let refreshControl = UIRefreshControl()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chela = chelas[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        // assign page view content loader
        let fBSignRegisterViewController = storyboard.instantiateViewController(withIdentifier: "chelaDetailSB")
            as? ViewControllerForChela;
        
        fBSignRegisterViewController?.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        let caracteristicas = ["% Alcohol":chela["Alcohol"],"Año":chela["anio"],"Color":chela["Color"],"Segmento":chela["segmento"],"Estilo":chela["estilo"],"IBU":chela["ibu"],"Amargor":chela["amargor"]]
        fBSignRegisterViewController?.ArrCaracteristicas = caracteristicas as! [String : String]
        fBSignRegisterViewController?.idChela = chela["idCerveza"]!
        
        var info: [String:String] = [:]
        if(chela["descripcion"]! != ""){
            info["Información"] = chela["descripcion"]!
        }
        if(chela["Lupulus"]! != ""){
             info["Lupulus"] = chela["Lupulus"]!
        }
        if(chela["Recomendado"]! != ""){
             info["Recomendado con"] = chela["Recomendado"]!
        }
        fBSignRegisterViewController?.ArrInformacion = info 
        fBSignRegisterViewController?.tituloChela = chela["Nombre"]!
        fBSignRegisterViewController?.imagen = "https://socios.soychelero.mx/img/tarjetas/\(String(describing: chela["imagen"]!))"
        DispatchQueue.main.async {
            self.present(fBSignRegisterViewController!, animated: true,completion: nil)
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chelas.count
    }
    
    var selectedIndex:Int = -1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chela") as! TableViewCellChelas
        cell.nombreLbl.text = chelas[indexPath.row]["Nombre"]
        cell.imageImg.contentMode = .scaleAspectFit
        
        let urlString = "https://socios.soychelero.mx/img/tarjetas/\(String(describing: chelas[indexPath.row]["imagen"]!))"
        let urlImg = URL(string: urlString)
        print(urlImg!)
        cell.imageImg.sd_setImage(with: urlImg, placeholderImage: UIImage.gifImageWithName("loader"))
        cell.ratingBar.rating = Double(chelas[indexPath.row]["valoracion"]!)!
        cell.id = indexPath.row
        cell.commentsBtn.badgeString = chelas[indexPath.row]["comments"]
        cell.ratingBar.didFinishTouchingCosmos = { rating in
            self.callSetRating(id: self.chelas[indexPath.row]["id"]!,rating: String(format: "%.0f", rating))
        }
        //cell.ratingBar.addGe
        //cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedCell(_:))))
        return cell
    }
    
    func callSetRating(id:String, rating:String){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "https://socios.soychelero.mx/back/cervezas.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=valorar&id=\(id)&rate=\(rating)"
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
                            print(json!)
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.separatorStyle = .none
        tabla.delegate = self
        tabla.dataSource = self
        tabla.tableFooterView = UIView()
        
        
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor().ColorChelero()
        tabla.insertSubview(refreshControl, at: 0)
        tabla.sendSubview(toBack: refreshControl)
        tabla.register(UINib(nibName: "TableViewCellChelas", bundle: nil), forCellReuseIdentifier: "chela")
        let vista = UIView(frame: self.view.frame)
        vista.backgroundColor = UIColor().hexStringToUIColor(hex: "474749")
        tabla.isUserInteractionEnabled = true
        tabla.backgroundView = vista
        tabla.insertSubview(refreshControl, at: 0)
        tabla.sendSubview(toBack: refreshControl)
        consumeWebServices()
        // Do any additional setup after loading the view.
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        consumeWebServices()
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
                            for i in 0..<self.chelas.count{
                                self.callAnotherWs(nuevaChela: self.chelas[i], completionBlock: { (c) in
                                    if c == "0"{
                                        self.chelas[i]["comments"] = ""
                                    }else{
                                        self.chelas[i]["comments"] = c
                                    }
                                })
                            }
                            self.refreshControl.endRefreshing()
                            self.tabla.reloadData()
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func callAnotherWs(nuevaChela:[String:String],completionBlock: @escaping (String) -> Void) -> Void{
        var new = nuevaChela
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let urlStr = "https://socios.soychelero.mx/back/cervezas.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=contarComentarios&id=\(nuevaChela["idCerveza"]!)"
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
                        
                            var comentarios = ""
                            guard let success = json?.value(forKey: "success") as? Bool else{
                                completionBlock(comentarios)
                                return
                            }
                            guard let records = json?.value(forKey: "records") as? Int, records > 0 else{
                                completionBlock(comentarios)
                                return
                            }
                            guard let root = json?.value(forKey: "root") as? NSArray else{
                                completionBlock(comentarios)
                                return
                            }
                            guard let obj = root.object(at: 0) as? NSObject else{
                                completionBlock(comentarios)
                                return
                            }
                            guard let count = obj.value(forKey: "count") as? String else{
                                completionBlock(comentarios)
                                return
                            }
                            comentarios = count
                            completionBlock(comentarios)
                        
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func parsea(json: NSDictionary){
        let success = json.value(forKey: "success") as! Bool
        let records = json.value(forKey: "records") as! Int
        if(success && records > 0){
            let root = json.value(forKey: "root") as! NSArray
            self.chelas = []
            for chela in root{
                let chelaDic = chela as! NSDictionary
                /* "descripcion": "Esta porter tiene todos los sabores que uno espera de este estilo de cerveza: malta tostada, caramelo, chocolate y café. Se trata de una receta de principios del siglo 18, cuando las cervezas porters se elaboraban al mezclar tres tipos de cervezas ale diferentes. La Cervecería Seis Hileras fue fundada por tres jóvenes hermanos en Atizapán, México.",
                 "ingredientes": null,
                 "lupulus": null,
                 "alcohol": "5.5",
                 "color": "Café",
                 "anio": "Siglo XVIII",
                 "fechaCreacion": "2018-01-09 00:12:27",
                 "imagen": "seisHilerasPorter.png",
                 "fechaPublicacion": null,
                 "segmento": "Ale",
                 "estilo": "Stouts And Porters",
                 "ibu": "35",
                 "amargor": "2",
                 "recomendado": "",*/
                
                
                var nuevaChela:[String:String] = [:]
                if let idCerveza = chelaDic.value(forKey: "idCerveza") as? String{
                    nuevaChela["idCerveza"] = idCerveza
                }else{
                    nuevaChela["idCerveza"] = ""
                }
                
                if let imagen = chelaDic.value(forKey: "imagen") as? String{
                    nuevaChela["imagen"] = imagen
                }else{
                    nuevaChela["imagen"] = ""
                }
                
                if let nombreChela = chelaDic.value(forKey: "nombre") as? String{
                    nuevaChela["Nombre"] = nombreChela
                }else{
                    nuevaChela["Nombre"] = ""
                }
                
                if let valoracion = chelaDic.value(forKey: "valoracion") as? String{
                    nuevaChela["valoracion"] = valoracion
                }else{
                    nuevaChela["valoracion"] = "0.0"
                }
                
                if let descripcion = chelaDic.value(forKey: "descripcion") as? String{
                    nuevaChela["descripcion"] = descripcion
                }else{
                    nuevaChela["descripcion"] = ""
                }
                
                if let ingredientes = chelaDic.value(forKey: "ingredientes") as? String{
                    nuevaChela["Ingredientes"] = ingredientes
                }else{
                    nuevaChela["Ingredientes"] = ""
                }
                
                if let lupulus = chelaDic.value(forKey: "lupulus") as? String{
                    nuevaChela["Lupulus"] = lupulus
                }else{
                    nuevaChela["Lupulus"] = ""
                }
                
                if let recomendado = chelaDic.value(forKey: "recomendado") as? String{
                    nuevaChela["Recomendado"] = recomendado
                }else{
                    nuevaChela["Recomendado"] = ""
                }
                
                if let alcohol = chelaDic.value(forKey: "alcohol") as? String{
                    nuevaChela["Alcohol"] = alcohol
                }else{
                    nuevaChela["Alcohol"] = ""
                }
                
                if let color = chelaDic.value(forKey: "color") as? String{
                    nuevaChela["Color"] = color
                }else{
                    nuevaChela["Color"] = ""
                }
                
                if let anio = chelaDic.value(forKey: "anio") as? String{
                    nuevaChela["anio"] = anio
                }else{
                    nuevaChela["anio"] = ""
                }
                
                if let segmetno = chelaDic.value(forKey: "segmento") as? String{
                    nuevaChela["segmento"] = segmetno
                }else{
                    nuevaChela["segmento"] = ""
                }
                
                if let estilo = chelaDic.value(forKey: "estilo") as? String{
                    nuevaChela["estilo"] = estilo
                }else{
                    nuevaChela["estilo"] = ""
                }
                
                if let ibu = chelaDic.value(forKey: "ibu") as? String{
                    nuevaChela["ibu"] = ibu
                }else{
                    nuevaChela["ibu"] = ""
                }
                
                if let amargor = chelaDic.value(forKey: "amargor") as? String{
                    nuevaChela["amargor"] = amargor
                }else{
                    nuevaChela["amargor"] = ""
                }
            
                if let id = chelaDic.value(forKey: "id") as? String{
                    nuevaChela["id"] = id
                }else{
                    nuevaChela["id"] = ""
                }
                
                
                self.chelas.append(nuevaChela)
                
               
                
            }
            
            let myArraySorted = chelas.sorted{Int($0["valoracion"]!)! > Int($1["valoracion"]!)!}
            chelas = myArraySorted
            
        }
        
    }

}
