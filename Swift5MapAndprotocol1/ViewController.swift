//
//  ViewController.swift
//  Swift5MapAndprotocol1
//
//  Created by 西村拓晃 on 2021/09/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchLocationDelegate {
    
    
    
    
    var addressString = ""
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var locManager:CLLocationManager!
    @IBOutlet weak var addressLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        settingButton.backgroundColor = .white
        settingButton.layer.cornerRadius = 20.0
        

    }
    

    
    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            //senderはtapを開始した時
            
            
        }else if sender.state == .ended{
            //tapを終了
            
            //tapした位置を指定して、MKMapView上の井戸を取得する
            
            //軽度緯度から住所に変換する
            
            let tapPoint = sender.location(in: view)
            
            //タップした位置を指定してMKMapView上の経度緯度を取得する
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let lat = center.latitude
            let log = center.longitude
            convert(lat: lat, log: log)
        }
        
        
        
    }
    
    func convert(lat:CLLocationDegrees, log:CLLocationDegrees) {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        //クロージャー
        geocoder.reverseGeocodeLocation(location) {
            (MKPlacemark, Error) in
            
            if let placeMark = MKPlacemark{
                
                if let pm = placeMark.first {
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    }else {
                        self.addressString = pm.name!
                    }
                    
                    self.addressLabel.text = self.addressString
                }
            }
        }
    }
    
    
    @IBAction func goToSearchVC(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
        
            
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let nextVC = segue.destination as! NextViewController
            nextVC.delegate = self
        }
    }
    //任されたデリゲートメソッド
    func searchLocation(idoValue: String, keidoValue: String) {
        if idoValue.isEmpty != true && keidoValue.isEmpty != true {
            let idoString = idoValue
            let keidoString = keidoValue
            
            //緯度経度からコーディネート
            let coordinate = CLLocationCoordinate2DMake(Double(idoString)!, Double(keidoString)! )
            
            //表示する範囲を指定する
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            //領域を指定する
            let region = MKCoordinateRegion(center: coordinate, span: span)
            //領域をmapviewに設定する
            mapView.setRegion(region, animated: true)
            //緯度経度から住所へ変換する
            convert(lat: Double(idoString)!, log: Double(keidoString)!)
            //ラベルに憑依する
            addressLabel.text = addressString
        }else{
            addressLabel.text = "表示できません"
        }
        
    }
    
    
}

