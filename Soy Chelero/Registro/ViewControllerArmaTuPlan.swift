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
    let colorChelero = UIColor().hexStringToUIColor(hex: "C4895A").cgColor
    
    let UIColorChelero = UIColor().hexStringToUIColor(hex: "C4895A")
    
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
            case 1:
                //Checamos que un boton de abajo este picado
                if arrCad[0].backgroundColor == UIColorChelero{
                    precioMem = "$ 90"
                    totalChelas = "2"
                }else if arrCad[1].backgroundColor == UIColorChelero{
                    precioMem = "$ 250"
                    totalChelas = "6"
                }else if arrCad[2].backgroundColor == UIColorChelero{
                    precioMem = "$ 500"
                    totalChelas = "12"
                }
            case 2:
                if arrCad[0].backgroundColor == UIColorChelero{
                    precioMem = "$ 180"
                    totalChelas = "4"
                }else if arrCad[1].backgroundColor == UIColorChelero{
                    precioMem = "$ 500"
                    totalChelas = "12"
                }else if arrCad[2].backgroundColor == UIColorChelero{
                    precioMem = "$ 999"
                    totalChelas = "24"
                }
            case 3:
                if arrCad[0].backgroundColor == UIColorChelero{
                    precioMem = "$ 250"
                    totalChelas = "6"
                }else if arrCad[1].backgroundColor == UIColorChelero{
                    precioMem = "$ 749"
                    totalChelas = "18"
                }else if arrCad[2].backgroundColor == UIColorChelero{
                    precioMem = "$ 1500"
                    totalChelas = "36"
                }
            case 4:
                if arrDif[0].backgroundColor == UIColorChelero{
                    precioMem = "$ 90"
                    totalChelas = "2"
                }else if arrDif[1].backgroundColor == UIColorChelero{
                    precioMem = "$ 180"
                    totalChelas = "4"
                }else if arrDif[2].backgroundColor == UIColorChelero{
                    precioMem = "$ 250"
                    totalChelas = "6"
                }
            case 5:
                if arrDif[0].backgroundColor == UIColorChelero{
                    precioMem = "$ 250"
                    totalChelas = "6"
                }else if arrDif[1].backgroundColor == UIColorChelero{
                    precioMem = "$ 500"
                    totalChelas = "12"
                }else if arrDif[2].backgroundColor == UIColorChelero{
                    precioMem = "$ 749"
                    totalChelas = "18"
                }
            case 6:
                if arrDif[0].backgroundColor == UIColorChelero{
                    precioMem = "$ 500"
                    totalChelas = "12"
                }else if arrDif[1].backgroundColor == UIColorChelero{
                    precioMem = "$ 999"
                    totalChelas = "24"
                }else if arrDif[2].backgroundColor == UIColorChelero{
                    precioMem = "$ 1500"
                    totalChelas = "36"
                }
            default:
                print("is not possibru")
            }
        
        precioLbl.text = precioMem
        totalChelasLbl.text = totalChelas
        
    }
    @IBAction func pressNext(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBDatosPersonales") as! ViewControllerRegistro
        newViewController.esCompleto = true
        self.present(newViewController, animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
