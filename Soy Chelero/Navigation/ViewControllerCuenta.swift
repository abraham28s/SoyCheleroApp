//
//  ViewControllerCuenta.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/03/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerCuenta: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInfo.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellbas", for: indexPath) as! TableViewCellDatosBasicos
            cell.nombreLbl.text? = arrInfo[0][0]
            cell.correoLbl.text = arrInfo[0][1]
            cell.telefonoLbl.text = arrInfo[0][2]
            return cell
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellenv", for: indexPath) as! TableViewCellDatosEnvio
            cell.calleNoLbl.text? = arrInfo[1][0]
            cell.coloniaLbl.text? = arrInfo[1][1]
            cell.municipioLbl.text? = arrInfo[1][2]
            cell.estadoCPLbl.text? = arrInfo[1][3]
            
            return cell
        case 2:
            let miPedido = Globales().pedidos[arrInfo[2][0]]
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellsub", for: indexPath) as! TableViewCellSubscripcion
            if(arrInfo[2][1] == "1"){
                cell.estatusLbl.textColor = UIColor().hexStringToUIColor(hex: "#2faf59")
                cell.estatusLbl.text = "· Activa"
            }else{
                cell.estatusLbl.textColor = UIColor().hexStringToUIColor(hex: "#d90d0d")
                cell.estatusLbl.text = "· Inactiva"
            }
            
            cell.recibirLbl.text = "\(miPedido![4]) Cervezas diferentes"
            cell.recibirImg.image = UIImage(named: "chela_\(miPedido![4])-dif")
            cell.conLbl.text = "\(miPedido![5]) de cada una"
            cell.conImg.image = UIImage(named: "chela_\(miPedido![5])-cada")
            cell.totalLbl.text = "\(miPedido![3]) cervezas"
            cell.totalImg.image = UIImage(named: "chela_12-cada")
            let urlString = "https://socios.soychelero.mx/img/tarjetas/\(String(describing: arrInfo[2][3])).png"
            let urlImg = URL(string: urlString)
            cell.tipoTarjetaImg.sd_setImage(with: urlImg)
            cell.terminacionTarjeta.text = "*****\(String(describing: arrInfo[2][4]))"
            if arrInfo[2][2] == "México" || arrInfo[2][2] == "Ciudad de México" {
                
                cell.subscripcionLbl.text = "$ \(miPedido![0] + miPedido![1])"
            }else{
                
                cell.subscripcionLbl.text = "$ \(miPedido![0] + miPedido![2])"
            }
            return cell
        default:
            
            return UITableViewCell()
        }
        
    }
    
    @IBOutlet weak var tablaPrincipal: UITableView!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var nivelLbl: UILabel!
    @IBOutlet weak var nombreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callBasicsWs()
        tablaPrincipal.register(UINib(nibName: "TableViewCellSubscripcion", bundle: nil), forCellReuseIdentifier: "cellsub")
        tablaPrincipal.register(UINib(nibName: "TableViewCellDatosEnvio", bundle: nil), forCellReuseIdentifier: "cellenv")
        tablaPrincipal.register(UINib(nibName: "TableViewCellDatosBasicos", bundle: nil), forCellReuseIdentifier: "cellbas")
        tablaPrincipal.dataSource = self
        tablaPrincipal.delegate = self
    }
    
    var arrInfo:[[String]] = []
    
    func callBasicsWs(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "https://socios.soychelero.mx/back/cuenta.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=traerDatosBasicos&usuario=\(String(describing: idUser!))"
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
                                
                            if (success && records > 0){
                                let root = json?.value(forKey: "root") as! NSArray
                                let rec = root[0] as! NSDictionary
                                var nuevo:[String] = []
                                    
                                nuevo.append("\(rec.value(forKey: "nombre") as! String) \(rec.value(forKey: "apellido") as! String)")
                                self.nombreLbl.text = nuevo[0]
                                nuevo.append(rec.value(forKey: "correo") as! String)
                                nuevo.append(rec.value(forKey: "telefono") as! String)
                                self.arrInfo.append(nuevo)
                                self.nivelLbl.text = "Nivel: \(rec.value(forKey: "nivel") as! String)"
                                let urlString = "https://socios.soychelero.mx/img/imgPerfil/\(String(describing: rec.value(forKey: "imagenPerfil") as! String))"
                                let urlImg = URL(string: urlString)
                                //print(urlImg!)
                                //print("test col")
                                self.imagenPerfil.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "no_photo-profile"))
                                
                                 self.imagenPerfil.setRounded()
                                
                                print(self.arrInfo)
                                self.callEnvioWs()
                            }
                            /*
                             @IBOutlet weak var nombreLbl: UILabel!
                             @IBOutlet weak var correoLbl: UILabel!
                             @IBOutlet weak var telefonoLbl: UILabel!
                             */
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func callEnvioWs(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "https://socios.soychelero.mx/back/cuenta.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=traerDatosEnvio&usuario=\(String(describing: idUser!))"
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
                            
                            if (success && records > 0){
                                let root = json?.value(forKey: "root") as! NSArray
                                let rec = root[0] as! NSDictionary
                                var nuevo:[String] = []
                                
                                nuevo.append("\(rec.value(forKey: "calle") as! String), \(rec.value(forKey: "numeroExterior") as! String) \(rec.value(forKey: "numeroInterior") as! String)")
                                nuevo.append(rec.value(forKey: "colonia") as! String)
                                nuevo.append(rec.value(forKey: "municipio") as! String)
                                nuevo.append("\(rec.value(forKey: "estado") as! String), \(rec.value(forKey: "codigoPostal") as! String)")
                                self.arrInfo.append(nuevo)
                                
                                var nuevoSub:[String] = []
                                nuevoSub.append(rec.value(forKey: "idPlan") as! String)
                                nuevoSub.append(rec.value(forKey: "estatus") as! String)
                                nuevoSub.append(rec.value(forKey: "estado") as! String)
                                
                                self.arrInfo.append(nuevoSub)
                                
                                self.callSubWs()
                            }
                            /*
                             @IBOutlet weak var calleNoLbl: UILabel!
                             @IBOutlet weak var coloniaLbl: UILabel!
                             @IBOutlet weak var municipioLbl: UILabel!
                             @IBOutlet weak var estadoCPLbl: UILabel!
                             */
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func callSubWs(){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")
            let urlStr = "https://socios.soychelero.mx/back/cuenta.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=traerDatosTarjeta&usuario=\(String(describing: idUser!))"
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
                            
                            if (success && records > 0){
                                let root = json?.value(forKey: "root") as! NSArray
                                let rec = root[0] as! NSDictionary
                                
                                
                               
                                self.arrInfo[2].append(rec.value(forKey: "tipo") as! String)
                                self.arrInfo[2].append(rec.value(forKey: "numero") as! String)
                                
                                print(self.arrInfo)
                                self.tablaPrincipal.reloadData()
                            }
                            /*
                             @IBOutlet weak var calleNoLbl: UILabel!
                             @IBOutlet weak var coloniaLbl: UILabel!
                             @IBOutlet weak var municipioLbl: UILabel!
                             @IBOutlet weak var estadoCPLbl: UILabel!
                             */
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
