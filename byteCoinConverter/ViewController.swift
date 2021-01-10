//
//  ViewController.swift
//  byteCoinConverter
//
//  Created by Qenawi on 1/10/21.
//  Copyright © 2021 qenawi. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource,ByteCoinMangerDeligate, UIPickerViewDelegate {
    func onDataExcangeReady()
    {
        exchangeAmount.text = "\(String(describing: manger.excahngeValue?.fromCoin)) -> \(String(describing: manger.excahngeValue?.toCoin)) = \(String(describing: manger.excahngeValue?.toCoin)) "
    }
    @IBOutlet weak var exchangeAmount: UILabel!
    
    func onDataReady()
    {
        self.amount.text = String(self.manger.pickerData[0].rate ?? 0.0)
        picker.reloadAllComponents()
    }
    
    func onDataFail(e: Error) {
        
    }
    
    let manger = ByteCoinManger()
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        // number of component to pick
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        manger.pickerData.count
    }
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var amount: UILabel!
    let locationManger = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        manger.deligate = self
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
        picker.dataSource = self
        picker.delegate = self
        manger.getPickerData()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let alert = UIAlertController(title: "location aquired", message: "\(locations.last?.coordinate.latitude ?? 0.0)", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: {
            Thread.sleep(forTimeInterval: 1.0)
        })
        alert.dismiss(animated: true, completion: nil)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        manger.pickerData[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.amount.text = String(self.manger.pickerData[row].rate ?? 0.0)
        self.manger.getExcangeData(dd:self.manger.pickerData[row].name ?? "BSD" )
    }
}

