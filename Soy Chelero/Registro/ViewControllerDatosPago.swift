//
//  ViewControllerDatosPago.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 04/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ViewControllerDatosPago: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker{
            return arrMonths[row]
        }else{
            return arrYears[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker{
            return arrMonths.count
        }else{
            return arrYears.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthPicker{
            MonthTxt.text = arrMonths[row]
        }else{
            yearTxt.text = arrYears[row]
        }
    }
    
    let arrMonths = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    let arrYears = ["18","19","20","21","22","23","24","25","26","27","28","29","30"]
    @IBOutlet weak var numeroTarjeta: TextFieldFancy!
    
    @IBOutlet weak var CVV: TextFieldFancy!
    @IBOutlet weak var yearTxt: TextFieldFancy!
    @IBOutlet weak var MonthTxt: TextFieldFancy!
    @IBOutlet weak var nombreTxt: TextFieldFancy!
    let monthPicker = UIPickerView()
    let YearPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MonthTxt.text = arrMonths[0]
        yearTxt.text = arrYears[0]
        monthPicker.delegate = self
        YearPicker.delegate = self
        yearTxt.inputView = YearPicker
        MonthTxt.inputView = monthPicker
        
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
        yearTxt.inputAccessoryView = toolBar
        MonthTxt.inputAccessoryView = toolBar
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func donePicker(){
        self.view.endEditing(true)
        
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
        
    }
    
    @objc func tapped(){
        self.view.endEditing(true)
    }
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pressPay(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPrincipal") as UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBLogin") as UIViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressEtomin(_ sender: Any) {
        if let url = URL(string: "http://etomin.com/"){
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
