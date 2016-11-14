//
//  ViewController.swift
//  Recorrido
//
//  Created by Andrés Ixpec on 9/11/16.
//  Copyright © 2016 Andrés Ixpec. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapa: MKMapView!
    
    let manejadorMapa = CLLocationManager()
    var puntoAnterior = CLLocation(latitude: 0, longitude: 0)
    var punto = CLLocationCoordinate2D()
    var distancia = 0.0 
    var distanciaRecorrida = 0.0
    
    @IBAction func clickButtonNormal() {
        mapa.mapType = .standard
        
    }
    
    @IBAction func clickButtonSatelite() {
         mapa.mapType = .satellite
    }
    
    @IBAction func clickButtonHibrido() {
         mapa.mapType = .hybrid
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejadorMapa.delegate = self
        manejadorMapa.desiredAccuracy = kCLLocationAccuracyBest
        manejadorMapa.requestWhenInUseAuthorization()
        
        
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            manejadorMapa.startUpdatingLocation()
            mapa.showsUserLocation = true
            
        }
        else{
            manejadorMapa.stopUpdatingLocation()
        }
    }
    
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if distancia == 0.0{
            if mapa.userLocation.location != nil{
                puntoAnterior = mapa.userLocation.location!
      
                mapa.setUserTrackingMode(.follow, animated: true)
                distancia = puntoAnterior.distance(from: manejadorMapa.location!)
            }
        }
        else{
            distancia = puntoAnterior.distance(from: manejadorMapa.location!)
        
            if (distancia>=50 ){
                self.establecerPunto(latitud: manejadorMapa.location!.coordinate.latitude, longitud: manejadorMapa.location!.coordinate.longitude)
                puntoAnterior=manejadorMapa.location!
                self.distanciaRecorrida += distancia
            }
        
        }
        
        
    }
    
    
    
    func establecerPunto(latitud:CLLocationDegrees, longitud:CLLocationDegrees){
     
        
            punto.latitude = latitud
            punto.longitude = longitud
            let pin = MKPointAnnotation()
            pin.title = "lat:\(latitud), long:\(longitud)S"
            pin.subtitle = "Recorrido: \(self.distanciaRecorrida) m."
            pin.coordinate = punto
            mapa.addAnnotation(pin)
     
        
      
    }

}

