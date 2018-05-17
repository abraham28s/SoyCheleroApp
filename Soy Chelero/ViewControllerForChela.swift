//
//  ViewControllerForChela.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 24/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerForChela: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var imgContainer: UIView!
    
    var tituloChela = ""
    var imagen = ""
    var idChela = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewCaracteristicas{
            return ArrCaracteristicas.count
        }
        if tableView == tableViewInformacion{
            return ArrInformacion.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableViewCaracteristicas{
            cell = tableView.dequeueReusableCell(withIdentifier: "caracteristicasCell")!
            cell.textLabel?.font = UIFont (name: "RobotoSlab-Light", size: 15)
            cell.textLabel?.text = arrLlavesCar[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.text = ArrCaracteristicas[arrLlavesCar[indexPath.row]]
            
        }
        if tableView == tableViewInformacion{
            
                cell = tableView.dequeueReusableCell(withIdentifier: "informacionCell")!
                cell.textLabel?.font = UIFont (name: "RobotoSlab-Bold", size: 15)
                cell.textLabel?.text = arrLlavesInfo[indexPath.row]
                cell.textLabel?.textColor = UIColor.white
                
                cell.detailTextLabel?.text = ArrInformacion[arrLlavesInfo[indexPath.row]]
            
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
         imgContainer.layer.cornerRadius = 5
        tituloLbl.text = self.tituloChela
        let urlString = self.imagen
        let urlImg = URL(string: urlString)
        chelaImg.sd_setImage(with: urlImg)
    }
    @IBOutlet weak var tituloLbl: UILabel!
    @IBOutlet weak var chelaImg: UIImageView!
    var ArrCaracteristicas:[String:String] = [:]
    var ArrInformacion:[String:String] = [:]
    var arrLlavesCar : [String] = []
    var arrLlavesInfo : [String] = []
    
    @IBOutlet weak var tableViewInformacion: UITableView!
    @IBOutlet weak var tableViewCaracteristicas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrLlavesCar = Array(ArrCaracteristicas.keys)
        arrLlavesInfo = Array(ArrInformacion.keys)
        tableViewInformacion.tableFooterView = UIView()
        tableViewCaracteristicas.tableFooterView = UIView()
        let vista = UIView(frame: tableViewCaracteristicas.frame)
        vista.backgroundColor = UIColor().hexStringToUIColor(hex: "474749")
        tableViewCaracteristicas.backgroundView = vista
        tableViewCaracteristicas.dataSource = self
        tableViewCaracteristicas.delegate = self
        
        let vista2 = UIView(frame: tableViewInformacion.frame)
        vista2.backgroundColor = UIColor().hexStringToUIColor(hex: "474749")
        tableViewInformacion.backgroundView = vista2
        tableViewInformacion.dataSource = self
        tableViewInformacion.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressComments(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBComentarios") as! ViewControllerComments
        newViewController.idChela = idChela
        self.present(newViewController, animated: true, completion: nil)
    }
    

}
