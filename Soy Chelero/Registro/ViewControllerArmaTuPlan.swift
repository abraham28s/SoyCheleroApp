//
//  ViewControllerArmaTuPlan.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 04/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerArmaTuPlan: UIViewController {
    
    
    @IBOutlet weak var oneDifBtn: UIControl!
    @IBOutlet weak var twoDifBtn: UIControl!
    @IBOutlet weak var threeDifBtn: UIControl!
    
    @IBOutlet weak var twoCadBtn: UIControl!
    @IBOutlet weak var sixCadBtn: UIControl!
    @IBOutlet weak var twelveCadBtn: UIControl!
    
    @IBOutlet weak var precioLbl: UILabel!
    @IBOutlet weak var totalChelasLbl: UILabel!
    var arrDif:[UIControl] = []
    var arrCad:[UIControl] = []
    let colorChelero = UIColor().hexStringToUIColor(hex: "#c1996f").cgColor
    
    let UIColorChelero = UIColor().hexStringToUIColor(hex: "#c1996f")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrDif = [oneDifBtn,twoDifBtn,threeDifBtn]
        arrCad = [twoCadBtn,sixCadBtn,twelveCadBtn]
        
        
        let borderWidth: CGFloat = 2.0
        oneDifBtn.layer.borderColor = colorChelero
        oneDifBtn.layer.borderWidth = borderWidth
        oneDifBtn.backgroundColor = UIColor.white
        
        twoDifBtn.layer.borderColor = colorChelero
        twoDifBtn.layer.borderWidth = borderWidth
        twoDifBtn.backgroundColor = UIColor.white
        
        threeDifBtn.layer.borderColor = colorChelero
        threeDifBtn.layer.borderWidth = borderWidth
        threeDifBtn.backgroundColor = UIColor.white
        
        twoCadBtn.layer.borderColor = colorChelero
        twoCadBtn.layer.borderWidth = borderWidth
        twoCadBtn.backgroundColor = UIColor.white
        
        sixCadBtn.layer.borderColor = colorChelero
        sixCadBtn.layer.borderWidth = borderWidth
        sixCadBtn.backgroundColor = UIColor.white
        
        twelveCadBtn.layer.borderColor = colorChelero
        twelveCadBtn.layer.borderWidth = borderWidth
        twelveCadBtn.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isMayorEdad") == false{
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPrivacidad") as UIViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func pressButton(_ sender: UIControl) {
        if sender.tag == 1 || sender.tag == 2 || sender.tag == 3{
            for btn in arrDif {
                let imageVw = btn.subviews[0] as! UIImageView
                imageVw.image = imageVw.image!.withRenderingMode(.alwaysTemplate)
                
                let lab = btn.subviews[1] as! UILabel
                if btn.tag == sender.tag{
                    btn.backgroundColor = UIColorChelero
                    lab.textColor = UIColor.white
                    imageVw.tintColor = UIColor.white
                }else{
                    btn.backgroundColor = UIColor.white
                    lab.textColor = UIColor.black
                    imageVw.tintColor = UIColorChelero
                }
            }
        }
        else if sender.tag == 4 || sender.tag == 5 || sender.tag == 6{
            for btn in arrCad {
                let imageVw = btn.subviews[0] as! UIImageView
                imageVw.image = imageVw.image!.withRenderingMode(.alwaysTemplate)
                
                let lab = btn.subviews[1] as! UILabel
                if btn.tag == sender.tag{
                    btn.backgroundColor = UIColorChelero
                    lab.textColor = UIColor.white
                    imageVw.tintColor = UIColor.white
                }else{
                    btn.backgroundColor = UIColor.white
                    lab.textColor = UIColor.black
                    imageVw.tintColor = UIColorChelero
                }
            }
        }
        
        let newArr = arrDif + arrCad
        var precioMem = "$ 0"
        var totalChelas = "0"
        
        switch sender.tag{
        //Una cerveza diferente
        case 1:
            //Checamos que un boton de abajo este picado
            //una diferente 2 de cada una
            if arrCad[0].backgroundColor == UIColorChelero{
                precioMem = "$ 90"
                totalChelas = "2"
                UserDefaults.standard.set("1", forKey: "idPedido")
                
                // una diferente 6 de cada una
            }else if arrCad[1].backgroundColor == UIColorChelero{
                precioMem = "$ 250"
                totalChelas = "6"
                UserDefaults.standard.set("2", forKey: "idPedido")
                
                // una diferente 12 de cada una
            }else if arrCad[2].backgroundColor == UIColorChelero{
                precioMem = "$ 500"
                totalChelas = "12"
                UserDefaults.standard.set("3", forKey: "idPedido")
            }
        //Dos cerveza diferente
        case 2:
            
            //dos diferentes dos de cada una
            if arrCad[0].backgroundColor == UIColorChelero{
                precioMem = "$ 180"
                totalChelas = "4"
               UserDefaults.standard.set("4", forKey: "idPedido")
                //dos diferentes 6 de cada una
            }else if arrCad[1].backgroundColor == UIColorChelero{
                precioMem = "$ 500"
                totalChelas = "12"
                UserDefaults.standard.set("5", forKey: "idPedido")
                // dos diferentes, 12 de cada una
            }else if arrCad[2].backgroundColor == UIColorChelero{
                precioMem = "$ 999"
                totalChelas = "24"
                UserDefaults.standard.set("6", forKey: "idPedido")
            }
        //Tres cerveza diferente
        case 3:
            // 3 diferentes, 2 de cada una
            if arrCad[0].backgroundColor == UIColorChelero{
                precioMem = "$ 250"
                totalChelas = "6"
                UserDefaults.standard.set("7", forKey: "idPedido")
                // 3 diferentes, 6 de cada una
            }else if arrCad[1].backgroundColor == UIColorChelero{
                precioMem = "$ 749"
                totalChelas = "18"
                 UserDefaults.standard.set("8", forKey: "idPedido")
                // 3 diferentes, 12 de cada una
            }else if arrCad[2].backgroundColor == UIColorChelero{
                precioMem = "$ 1500"
                totalChelas = "36"
                UserDefaults.standard.set("9", forKey: "idPedido")
            }
        //dos de cada una
        case 4:
            // dos de cada una, una diferente
            if arrDif[0].backgroundColor == UIColorChelero{
                precioMem = "$ 90"
                totalChelas = "2"
                UserDefaults.standard.set("1", forKey: "idPedido")
                
                // dos de cada una, dos difertenes
            }else if arrDif[1].backgroundColor == UIColorChelero{
                precioMem = "$ 180"
                totalChelas = "4"
                UserDefaults.standard.set("4", forKey: "idPedido")
                // dos de cada una tres diferentes
            }else if arrDif[2].backgroundColor == UIColorChelero{
                precioMem = "$ 250"
                totalChelas = "6"
                UserDefaults.standard.set("7", forKey: "idPedido")
            }
        ////Seis de cada una
        case 5:
            // seid de cada una una diferente
            if arrDif[0].backgroundColor == UIColorChelero{
                precioMem = "$ 250"
                totalChelas = "6"
                UserDefaults.standard.set("2", forKey: "idPedido")
                // seis de cada una dos diferentes
            }else if arrDif[1].backgroundColor == UIColorChelero{
                precioMem = "$ 500"
                totalChelas = "12"
               UserDefaults.standard.set("5", forKey: "idPedido")
                // 6 de cada una 3 diferentes
            }else if arrDif[2].backgroundColor == UIColorChelero{
                precioMem = "$ 749"
                totalChelas = "18"
                UserDefaults.standard.set("8", forKey: "idPedido")
            }
        //12 de cada una
        case 6:
            //12 de cada una, una diferente
            if arrDif[0].backgroundColor == UIColorChelero{
                precioMem = "$ 500"
                totalChelas = "12"
               UserDefaults.standard.set("3", forKey: "idPedido")
                //12 de cada una, dos diferentes
            }else if arrDif[1].backgroundColor == UIColorChelero{
                precioMem = "$ 999"
                totalChelas = "24"
                UserDefaults.standard.set("6", forKey: "idPedido")
                //12 de cada una, tres diferentes
            }else if arrDif[2].backgroundColor == UIColorChelero{
                precioMem = "$ 1500"
                totalChelas = "36"
                UserDefaults.standard.set("9", forKey: "idPedido")
            }
        default:
            print("is not possibru")
        }
        
        precioLbl.text = precioMem
        totalChelasLbl.text = totalChelas
        
    }
    @IBAction func pressNext(_ sender: Any) {
        if(planIsSelected()){
            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosPersonales") as! ViewControllerRegistro
            newViewController.esCompleto = true
            self.present(newViewController, animated: true, completion: nil)
        }else{
            let alerta = UIAlertController(title: "Error", message: "Debes seleccionar un plan", preferredStyle: .alert)
            let accion = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alerta.addAction(accion)
            self.present(alerta, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func planIsSelected() -> Bool{
        return precioLbl.text != "$ 0" && totalChelasLbl.text != "0"
    }
    
    @IBAction func pressOnlyRegister(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosPersonales") as! ViewControllerRegistro
        newViewController.esCompleto = false
        self.present(newViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
