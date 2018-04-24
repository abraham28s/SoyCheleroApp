//
//  ViewControllerLogin.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 12/03/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerLogin: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var viewLoginForm: UIView!
    @IBOutlet weak var btnEntrar: UIButton!
    @IBOutlet weak var btnRegistrarse: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var LblErrorCorreo: UILabel!
    @IBOutlet weak var LblErrorPassword: UILabel!
    @IBOutlet weak var loginForm: UIView!
    var loginFrmAlwPos = CGRect()
    var tecladoMostrado = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // corner radius
        txtEmail.delegate = self
        txtEmail.returnKeyType = .next
        txtPassword.delegate = self
        txtPassword.returnKeyType = .continue
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        loginFrmAlwPos = loginForm.frame
        txtPassword.addTarget(self, action: #selector(textPassDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let color = UIColor()
        viewLoginForm.layer.cornerRadius = 10
        // shadow
        viewLoginForm.layer.shadowColor = color.hexStringToUIColor(hex: "CCCCCD").cgColor
        viewLoginForm.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewLoginForm.layer.shadowOpacity = 0.7
        viewLoginForm.layer.shadowRadius = 4.0
        //////
        
        
        btnEntrar.layer.cornerRadius = 3
        btnRegistrarse.layer.cornerRadius = 3
        btnRegistrarse.layer.borderWidth = 0.5
        txtEmail.layer.borderWidth = 0.5
        txtEmail.layer.borderColor = UIColor.gray.cgColor
        txtEmail.layer.cornerRadius = 3
        btnRegistrarse.layer.borderColor = UIColor.gray.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        print("Va a salir el teclado")
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if(!tecladoMostrado){
                tecladoMostrado = true
                print("Se va a hacer un resize")
                //self.view.frame.origin.y -= keyboardSize.height
                
                self.loginForm.frame = CGRect(x: loginFrmAlwPos.origin.x, y: loginFrmAlwPos.origin.y-keyboardSize.height, width: loginFrmAlwPos.width, height: loginFrmAlwPos.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if(tecladoMostrado){
                tecladoMostrado = false
                self.loginForm.frame = self.loginFrmAlwPos
                
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === txtEmail{
            txtPassword.becomeFirstResponder()
            return false
        }
        if textField === txtPassword{
            pressLoginBtn(UIButton())
            return false
        }
        return true
    }
    
    @objc func tapped(){
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let texto:String = textField.text!
        if(texto != ""){
            if(isEmailValid(testStr: texto)){
                LblErrorCorreo.text = ""
                LblErrorCorreo.isHidden = true
                textField.layer.borderColor = UIColor.gray.cgColor
            }else{
                LblErrorCorreo.text = "El correo no es valido."
                LblErrorCorreo.isHidden = false
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }else{
            LblErrorCorreo.text = ""
            LblErrorCorreo.isHidden = true
            textField.layer.borderColor = UIColor.gray.cgColor
        }
        
    }
    
    @objc func textPassDidChange(textField: UITextField) {
        let texto:String = textField.text!
        if(texto != ""){
            if(isPassValid(testStr: texto)){
                LblErrorPassword.text = ""
                LblErrorPassword.isHidden = true
                textField.layer.borderColor = UIColor.gray.cgColor
            }else{
                LblErrorPassword.text = "La contraseña no es valida."
                LblErrorPassword.isHidden = false
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }else{
            LblErrorPassword.text = ""
            LblErrorPassword.isHidden = true
            textField.layer.borderColor = UIColor.gray.cgColor
        }
        
    }
    
    @IBAction func pressRegisterBtn(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBArmaTuPlan") as UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func pressLoginBtn(_ sender: Any) {
        if(isEmailValid(testStr: txtEmail.text!) && isPassValid(testStr: txtPassword.text!)){
            consumeWebServices(correo: txtEmail.text!, contraseña: txtPassword.text!)
        }else{
            var mensaje = ""
            if !isEmailValid(testStr: txtEmail.text!) && !isPassValid(testStr: txtPassword.text!) {
                mensaje = "Verifica email y password"
                
            }else if !isPassValid(testStr: txtPassword.text!){
                mensaje = "Verifica password."
            }else if !isEmailValid(testStr: txtEmail.text!){
                mensaje = "Verifica email."
            }
            let alerta = UIAlertController(title: "Login Fallido", message: mensaje, preferredStyle: .alert)
            let accion = UIAlertAction(title: "Ok", style: .cancel, handler: { (alerta) in
                self.txtPassword.text = ""
            })
            alerta.addAction(accion)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    
    func consumeWebServices(correo:String,contraseña:String){
        let secondQueue = DispatchQueue.global()
        secondQueue.async {
            let urlStr = "https://socios.soychelero.mx/back/usuarios.php?action=logeo&usuario={\"correo\":\"\(correo)\",\"contrasenia\":\"\(contraseña)\"}"
            let encondedStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print(encondedStr)
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
                            let success = json?.value(forKey: "success") as! Bool
                            if(success){
                                let root = json?.value(forKey: "root") as! NSArray
                                let user = root[0] as! NSDictionary
                                let idUser = user.value(forKey: "idUsuario") as! String
                                print(idUser)
                                UserDefaults.standard.set(idUser, forKey: "isUser")
                                let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPrincipal") as UIViewController
                                self.present(newViewController, animated: true, completion: {
                                    UserDefaults.standard.set(true, forKey: "isLogged")
                                })
                            }else{
                                let messageText = json?.value(forKey: "messageText") as! String
                                let alerta = UIAlertController(title: "Login Fallido", message: messageText, preferredStyle: .alert)
                                let accion = UIAlertAction(title: "Ok", style: .cancel, handler: { (alerta) in
                                    self.txtPassword.text = ""
                                })
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
    
    func isEmailValid(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isPassValid(testStr:String) -> Bool {
        return testStr.count >= 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
