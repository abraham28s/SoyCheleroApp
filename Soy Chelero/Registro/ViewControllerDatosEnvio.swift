//
//  ViewControllerDatosEnvio.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 04/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit
import DropDown

class ViewControllerDatosEnvio: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrMunicipios.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrMunicipios[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coloniaDropDown.text = arrMunicipios[row]
        
    }
    
    var arrMunicipios:[String] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cpTxt: TextFieldFancy!
    @IBOutlet weak var municipioTxt: TextFieldFancy!
    @IBOutlet weak var estadoTxt: TextFieldFancy!
    @IBOutlet weak var coloniaDropDown: UITextField!
    @IBOutlet weak var facturacion: UISwitch!
    
    @IBOutlet weak var numExtTxt: TextFieldFancy!
    
    @IBOutlet weak var numIntTxt: TextFieldFancy!
    
    var prevText = ""
    var coloniaDD = UIPickerView()
    let miPedido = Globales().pedidos[UserDefaults.standard.string(forKey: "idPedido")!]
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var costoEnvioLbl: UILabel!
    @IBOutlet weak var totalChelasLbl: UILabel!
    @IBOutlet weak var precioSubLbl: UILabel!
    @IBOutlet weak var calleTxt: TextFieldFancy!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        precioSubLbl.text = "$ \(miPedido![0])"
        totalChelasLbl.text = "\(miPedido![3])"
        
        coloniaDD.delegate = self
        coloniaDropDown.inputView = coloniaDD
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        coloniaDropDown.inputAccessoryView = toolBar
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapped(){
        self.view.endEditing(true)
    }
    
    @objc func donePicker(){
        calleTxt.becomeFirstResponder()
        
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
    }
    
    @IBAction func cpChanged(_ sender: Any) {
        let cpTxt = sender as! UITextField
        if prevText != cpTxt.text{
            prevText = cpTxt.text!
            if cpTxt.text?.count == 5{
                print("here")
                webServiceColonia(cpTxt.text!)
            }
        }
        
    }
    
    func webServiceColonia(_ cp:String){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let urlStr = "https://secure.geonames.org/postalCodeLookupJSON?postalcode=\(cp)&country=MX&username=soychelero"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            //print(encondedStr)
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
                            let postalcodes = json?.value(forKey: "postalcodes") as! NSArray
                            if(postalcodes.count == 0){
                                let alert = UIAlertController(title: "Error", message: "Ingrese un codigo postal valido.", preferredStyle: .alert)
                                let accion = UIAlertAction(title: "Ok", style: .default, handler: { (send) in
                                    self.cpTxt.text = ""
                                })
                                alert.addAction(accion)
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                
                                self.arrMunicipios = []
                                for p in postalcodes{
                                    let ubi = p as! NSDictionary
                                    self.arrMunicipios.append(ubi.value(forKey: "placeName") as! String)
                                }
                                self.estadoTxt.text = (postalcodes[0] as! NSDictionary).value(forKey: "adminName1") as! String
                                self.municipioTxt.text = (postalcodes[0] as! NSDictionary).value(forKey: "adminName2") as! String
                               
                                if ((postalcodes[0] as! NSDictionary).value(forKey: "adminName1") as! String) == "México" || ((postalcodes[0] as! NSDictionary).value(forKey: "adminName1") as! String) == "Ciudad de México" {
                                    self.costoEnvioLbl.text = "$ \(self.miPedido![1])"
                                    self.totalLbl.text = "$ \(self.miPedido![0] + self.miPedido![1])"
                                }else{
                                    self.costoEnvioLbl.text = "$ \(self.miPedido![2])"
                                    self.totalLbl.text = "$ \(self.miPedido![0] + self.miPedido![2])"
                                }
                                
                                self.coloniaDropDown.text = self.arrMunicipios[0]
                           self.coloniaDropDown.becomeFirstResponder()
                                self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
                                print(self.arrMunicipios)
                            }
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    @IBAction func startEditinfNumExt(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startEditingNumInt(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
    }
    
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressNext(_ sender: Any) {
        if facturacion.isOn{
            let botonesListo = validarBotones()
            if(true/*botonesListo.count == 0*/){
                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosPago") as! UIViewController
                self.present(newViewController, animated: true, completion: nil)
            }else{
                let alerta = UIAlertController(title: "Error", message: botonesListo.joined(separator: "\n"), preferredStyle: .alert)
                let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alerta.addAction(accion)
                self.present(alerta, animated: true, completion: nil)
            }
        }else{
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosFacturacion") as! UIViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    func validarBotones() -> [String]{
        var result:[String] = []
        if cpTxt.text! == ""{
            result.append("El codigo postal es requerido.")
        }
        if calleTxt.text! == ""{
            result.append("La calle es requerida.")
        }
        if numExtTxt.text! == ""{
            result.append("El numero exterior es requerido.")
        }
        // TODO: - fecha nacimiento es mayor de edad
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cpTxt{
            coloniaDropDown.becomeFirstResponder()
            return false
        }
        if textField == calleTxt{
            numExtTxt.becomeFirstResponder()
            return false
        }
        if textField == numExtTxt{
            numIntTxt.becomeFirstResponder()
            return false
        }
        if textField == numIntTxt{
            if facturacion.isOn{
                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosPago") as! UIViewController
                self.present(newViewController, animated: true, completion: nil)
            }else{
                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosFacturacion") as! UIViewController
                self.present(newViewController, animated: true, completion: nil)
            }
            return false
        }
        return true
    }

}
