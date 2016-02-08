//
//  ViewController.swift
//  LoggingPath
//
//  Created by Hugo on 07/02/16.
//  Copyright © 2016 Hugo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var botones: UISegmentedControl!
    var manejador = CLLocationManager()
    @IBOutlet weak var mapa: MKMapView!
    var oldLocation : CLLocation!
    var newLocation : CLLocation!
    var totalDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.distanceFilter = 50.0
        mapa.userTrackingMode = MKUserTrackingMode.Follow
        manejador.requestWhenInUseAuthorization()
        
    }

    //Verifica autorización
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    //Recibe lecturas
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitud = manager.location!.coordinate.latitude
        let longitud = manager.location!.coordinate.longitude
        var punto = CLLocationCoordinate2D()
        punto.latitude = latitud
        punto.longitude = longitud
        
        /*var region = MKCoordinateRegion()
        region.center = punto;
        region.span.latitudeDelta = 0.014
        region.span.longitudeDelta = 0.014
        
        mapa.setRegion(region, animated: true)*/
        
        let pin = MKPointAnnotation()
        pin.title = "(\(latitud), \(longitud))"
        
        if oldLocation == nil{
            oldLocation = locations.first! as CLLocation
            pin.subtitle = "Distancia: 0"
        }else{
            newLocation = locations.last! as CLLocation
            let distance = oldLocation.distanceFromLocation(newLocation)
            oldLocation = newLocation
            totalDistance += distance
            pin.subtitle = "Distancia: \(totalDistance)"
        }
        
        pin.coordinate = punto
        mapa.addAnnotation(pin)

    }
    
    //Error
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController(title: "Error", message: "erro \(error.code)", preferredStyle: .Alert)
        let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {
            accion in
            //
        })
        alerta.addAction(accionOK)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    @IBAction func typeChanged(sender: AnyObject) {
        switch(botones.selectedSegmentIndex){
        case 0:
            mapa.mapType = MKMapType.Standard
        case 1:
            mapa.mapType = MKMapType.Satellite
        case 2:
            mapa.mapType = MKMapType.Hybrid
        default:
            mapa.mapType = MKMapType.Standard
        }
    }
}

