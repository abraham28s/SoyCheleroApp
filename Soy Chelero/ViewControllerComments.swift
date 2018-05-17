//
//  ViewControllerComments.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerComments: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellComment", for: indexPath) as! TableViewCellForComments
        cell.fecha.text = arrComments[indexPath.row][1]
        cell.nombre.text = arrComments[indexPath.row][2]
        cell.texto.text = arrComments[indexPath.row][3]
        let urlString = "https://socios.soychelero.mx/img/imgPerfil/\(arrComments[indexPath.row][0])"
        let urlImg = URL(string: urlString)
        print(urlImg!)
        cell.imagen?.sd_setImage(with: urlImg, placeholderImage:#imageLiteral(resourceName: "no_photo-profile"))
        cell.imagen?.contentMode = .scaleToFill
        cell.imagen.setRounded()
        
        return cell
    }
    
    @IBOutlet weak var tablaComentarios: UITableView!
    
    var originalTableFrame = CGRect()
    var originalVistaFrame = CGRect()
    var tecladoMostrado = false
    var idChela = ""
    var arrComments : [[String]] = []
    @IBAction func sendPressed(_ sender: Any) {
        let boton = sender as! UIButton
        boton.isEnabled = false
        mandarMensaje(self.comentarioTxt.text!)
        self.comentarioTxt.text = ""
    }
    
    func mandarMensaje(_ text: String){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let idUser = UserDefaults.standard.string(forKey: "isUser")!
            let urlStr = "https://socios.soychelero.mx/back/cervezas.php"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr!)
            let urlObject = URL(string: encondedStr!)
            var req = URLRequest(url: urlObject!)
            req.httpMethod = "POST"
            
            let postString = "action=enviarComentario&idCerveza=\(self.idChela)&idUsuario=\(idUser)&texto=\(text)"
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
                            //self.parsea(json: json!)
                            /*let success = json?.value(forKey: "success") as! Bool
                            
                            if(success){
                                
                                
                            }*/
                            print(json!)
                            self.consumeWebServices()
                            self.comentarioTxt.isEnabled = true
                            self.tablaComentarios.reloadData()
                        }
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var comentarioTxt: UITextField!
    @IBOutlet weak var vistaTexto: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tablaComentarios.delegate = self
        tablaComentarios.dataSource = self
        tablaComentarios.register(UINib(nibName: "TableViewCellForComments", bundle: nil), forCellReuseIdentifier: "cellComment")
        consumeWebServices()
        // Do any additional setup after loading the view.
    }
    
    @objc func tapped(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        originalTableFrame = tablaComentarios.frame
        originalVistaFrame = vistaTexto.frame
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Va a salir el teclado")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if(!tecladoMostrado){
                tecladoMostrado = true
                print("Se va a hacer un resize")
                //self.view.frame.origin.y -= keyboardSize.height
                
                self.vistaTexto.frame = CGRect(x: self.vistaTexto.frame.origin.x, y: self.vistaTexto.frame.origin.y - keyboardSize.height, width: self.vistaTexto.frame.width, height: self.vistaTexto.frame.height)
                
                self.tablaComentarios.frame = CGRect(x: self.tablaComentarios.frame.origin.x, y: self.tablaComentarios.frame.origin.y, width: self.vistaTexto.frame.width , height: self.tablaComentarios.frame.height - keyboardSize.height)
                
                self.tablaComentarios.scrollToRow(at: IndexPath(item:self.arrComments.count-1, section: 0), at: .bottom, animated: true)
            
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if(tecladoMostrado){
                tecladoMostrado = false
                self.tablaComentarios.frame = originalTableFrame
                self.vistaTexto.frame = originalVistaFrame
                
            }
        }
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
            
            let postString = "action=traerComentarios&id=\(self.idChela)"
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
                            //self.parsea(json: json!)
                            let success = json?.value(forKey: "success") as! Bool
                            let records = json?.value(forKey: "records") as! Int
                            if(success && records > 0){
                                let root = json?.value(forKey: "root") as! NSArray
                                self.arrComments = []
                                for rec in root{
                                    let entrada = rec as! NSDictionary
                                    let fecha = entrada.value(forKey: "fechaCreacion") as! String
                                    let index = fecha.index(fecha.startIndex, offsetBy: 11)
                                    let nuevaFecha = fecha[..<index]
                                    print(nuevaFecha)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateStyle = .medium
                                    dateFormatter.timeStyle = .none
                                    dateFormatter.locale = Locale(identifier: "en_US")
                                    
                                    let dateFormatter2 = DateFormatter()
                                    dateFormatter2.dateFormat = "yyyy-MM-dd"
                                    dateFormatter2.locale = Locale(identifier: "en_US")
                                    let date = dateFormatter2.date(from: String(nuevaFecha))
                                    let titulo = "\(entrada.value(forKey: "nombre") as! String) \(entrada.value(forKey: "apellido") as! String) dijo:"
                                    if let imagen = entrada.value(forKey: "imagen") as? String{
                                         let nuevo = [imagen, dateFormatter.string(from: date!), titulo, entrada.value(forKey: "texto") as! String]
                                        self.arrComments.append(nuevo)
                                    }else{
                                         let nuevo = ["", dateFormatter.string(from: date!), titulo, entrada.value(forKey: "texto") as! String]
                                        self.arrComments.append(nuevo)
                                    }
                                    
                                    
                                   
                                    
                                }
                                
                            }
                            //print(json!)
                            self.tablaComentarios.reloadData()
                            self.tablaComentarios.scrollToRow(at: IndexPath(item:self.arrComments.count-1, section: 0), at: .bottom, animated: true)
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
    
    @IBAction func pressClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
