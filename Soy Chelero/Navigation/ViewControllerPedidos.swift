//
//  ViewControllerPedidos.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 11/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerPedidos: UIViewController,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidosArr.count
    }
    @IBAction func changedValue(_ sender: Any) {
        let seg = sender as! UISegmentedControl
        pedidosArr = pedidosArrOriginal
        if seg.selectedSegmentIndex == 0 {
            pedidosArr = pedidosArrOriginal
            
        }
        if seg.selectedSegmentIndex == 1 {
            var result : [[String:String]] = []
            for pedido in pedidosArr{
                if pedido["estatus"]! == "1"{
                    result.append(pedido)
                }
            }
            pedidosArr = result
            
        }
        
        if seg.selectedSegmentIndex == 2 {
            var result : [[String:String]] = []
            for pedido in pedidosArr{
                if pedido["estatus"]! == "0"{
                    result.append(pedido)
                }
            }
            pedidosArr = result
        }
        tablaPrincipal.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pedidoCell") as! TableViewCellPedidos
        //let urlString = "https://socios.soychelero.mx/img/coasters/\(String(describing: coasterArr[indexPath.row]["imagen"]!))"
        //let urlImg = URL(string: urlString)
        //print(urlImg!)
        //cell.Img.sd_setImage(with: urlImg, placeholderImage: UIImage.gifImageWithName("loader"))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter2.locale = Locale(identifier: "en_US")
        let date = dateFormatter2.date(from: pedidosArr[indexPath.row]["fechaCreacion"]!)
        
        cell.fechaLbl.text = dateFormatter.string(from: date!)
        
        cell.paqueteLbl.text = "Paquete \(pedidosArr[indexPath.row]["idPlan"]!)"
        cell.precioLbl.text = String(format: "$%.2f", Double(pedidosArr[indexPath.row]["precio"]!)!)
        cell.tipoTarjetaLbl.text = pedidosArr[indexPath.row]["tipo"]!
        let urlString = "https://socios.soychelero.mx/img/tarjetas/\(String(describing: pedidosArr[indexPath.row]["tipo"]!)).png"
        let urlImg = URL(string: urlString)
        cell.tipoLbl.sd_setImage(with: urlImg)
        cell.terminacionTarjetaLBL.text = "*****\(pedidosArr[indexPath.row]["numero"]!)"
        if(pedidosArr[indexPath.row]["estatus"]! == "1"){
            cell.estatusImg.image = #imageLiteral(resourceName: "icn_compra_aprobada")
            cell.estatusLbl.textColor = UIColor().hexStringToUIColor(hex: "22C760")
            cell.estatusLbl.text = "Compra Aprobada"
        }else{
            cell.estatusImg.image = #imageLiteral(resourceName: "icn_compra_rechazada")
            cell.estatusLbl.textColor = UIColor().hexStringToUIColor(hex: "DF0605")
            cell.estatusLbl.text = "Compra Rechazada"
        }
        
        
        return cell
    }
    
    @IBOutlet weak var tablaPrincipal: UITableView!
    var pedidosArr:[[String:String]] = []
    var pedidosArrOriginal: [[String:String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPrincipal.dataSource = self
        tablaPrincipal.delegate = self
        tablaPrincipal.separatorStyle = .none
        tablaPrincipal.tableFooterView = UIView()
        tablaPrincipal.register(UINib(nibName: "TableViewCellPedidos", bundle: nil), forCellReuseIdentifier: "pedidoCell")
        let vista = UIView(frame: self.view.frame)
        vista.backgroundColor = UIColor().hexStringToUIColor(hex: "474749")
        tablaPrincipal.isUserInteractionEnabled = true
        tablaPrincipal.backgroundView = vista
        // Do any additional setup after loading the view.
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
            let urlStr = "https://socios.soychelero.mx/back/pedidos.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=traerPedidos&usuario=\(String(describing: idUser!))"
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
                            if(success){
                                let root = json?.value(forKey: "root") as! NSArray
                                for coa in root{
                                    let coaster = coa as! NSDictionary
                                    let nuevoDictionary:[String:String] = ["fechaCreacion":coaster.value(forKey: "fechaCreacion") as! String,"precio":coaster.value(forKey: "precio") as! String,"idSuscripcion":coaster.value(forKey: "idSuscripcion") as! String,"estatus":coaster.value(forKey: "estatus") as! String,"idPlan":coaster.value(forKey: "idPlan") as! String,"tipo":coaster.value(forKey: "tipo") as! String,"numero":coaster.value(forKey: "numero") as! String]
                                    self.pedidosArr.append(nuevoDictionary)
                                    //self.coa
                                    
                                    
                                }
                                //self.numPort.text = "\(self.coasterArr.count)"
                                //print(self.coasterArr)
                                self.pedidosArrOriginal = self.pedidosArr
                                self.tablaPrincipal.reloadData()
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

}
