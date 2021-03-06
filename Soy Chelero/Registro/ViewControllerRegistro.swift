//
//  ViewControllerRegistro.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 02/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerRegistro: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nombreTxt: TextFieldFancy!
    @IBOutlet weak var correoTxt: TextFieldFancy!
    @IBOutlet weak var contraseñaTxt: TextFieldFancy!
    @IBOutlet weak var confirmTxt: TextFieldFancy!
    @IBOutlet weak var telefonoTxt: TextFieldFancy!
    @IBOutlet weak var fechaNacimientoTxt: TextFieldFancy!
    var fechaPicker = UIDatePicker()
    
    var esCompleto:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tap)
        
        nombreTxt.delegate = self
        correoTxt.delegate = self
        contraseñaTxt.delegate = self
        confirmTxt.delegate = self
        telefonoTxt.delegate = self
        fechaNacimientoTxt.delegate = self
        fechaPicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        fechaNacimientoTxt.inputView = fechaPicker
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
        fechaNacimientoTxt.inputAccessoryView = toolBar
        
        
        if esCompleto{
            titleLbl.text = "DATOS DE REGISTRO"
            backBtn.setTitle("ATRAS", for: .normal)
            nextBtn.setTitle("SIGUIENTE", for: .normal)
            backBtn.addTarget(self, action: #selector(backActionComplete(sender:)), for: .touchUpInside)
            nextBtn.addTarget(self, action: #selector(nextActionComplete(sender:)), for: .touchUpInside)
        }else{
            titleLbl.text = "REGISTRARME SIN ADQUIRIR CHELA"
            backBtn.setTitle("SI QUIERO CHELA", for: .normal)
             nextBtn.setTitle("REGISTRARME", for: .normal)
            backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
            nextBtn.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        fechaNacimientoTxt.text = dateFormatter.string(from: sender.date)
        
    }
    
    @objc func donePicker(){
        self.view.endEditing(true)
        
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
    }
    
    @IBAction func startEditingFecha(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    @IBAction func endEditingFehca(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nombreTxt{
            correoTxt.becomeFirstResponder()
            return false
        }
        if textField === correoTxt{
            contraseñaTxt.becomeFirstResponder()
            return false
        }
        if textField === contraseñaTxt{
            confirmTxt.becomeFirstResponder()
            return false
        }
        if textField === confirmTxt{
            telefonoTxt.becomeFirstResponder()
            return false
        }
        if textField === telefonoTxt{
            fechaNacimientoTxt.becomeFirstResponder()
            return false
        }
        if textField === fechaNacimientoTxt{
            if esCompleto{
                nextActionComplete(sender: UIButton())
            }else{
                nextAction(sender: UIButton())
            }
            
            return false
        }
        
        return true
    }
    
    @objc func tapped(){
        self.view.endEditing(true)
    }
    
    @objc
    func backActionComplete(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func nextActionComplete(sender:UIButton){
        let botonesListo = validarBotones()
        if(true){//botonesListo.count == 0){
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosEnvio") as UIViewController
            self.present(newViewController, animated: true, completion: nil)
        }else{
            let alerta = UIAlertController(title: "Error", message: botonesListo.joined(separator: "\n"), preferredStyle: .alert)
            let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(accion)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @objc
    func backAction(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func nextAction(sender:UIButton){
        let botonesListo = validarBotones()
        if(true){//botonesListo.count == 0){
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPrincipal") as UIViewController
            self.present(newViewController, animated: true, completion: nil)
        }else{
            let alerta = UIAlertController(title: "Error", message: botonesListo.joined(separator: "\n"), preferredStyle: .alert)
            let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(accion)
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    func validarBotones() -> [String]{
        var result:[String] = []
        if nombreTxt.text! == ""{
            result.append("El nombre es requerido.")
        }
        if correoTxt.text! == ""{
            result.append("El correo es requerido.")
        }
        if contraseñaTxt.text! == ""{
            result.append("La contraseña es requerida.")
        }
        if confirmTxt.text! == ""{
            result.append("La confirmacion de contraseña es requerida.")
        }
        if telefonoTxt.text! == ""{
            result.append("El telefono es requerido.")
        }
        if fechaNacimientoTxt.text! == ""{
            result.append("La fecha de nacimiendo es requerida.")
        }
        if contraseñaTxt.text! != confirmTxt.text!{
            result.append("Las contraseñas deben ser iguales.")
        }
        
        // TODO: - fecha nacimiento es mayor de edad
        
        
        
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
