//
//  ViewController.swift
//  LocateBatman
//
//  Created by Aarón Cervantes Álvarez on 15/05/21.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController, MKMapViewDelegate {
  
  private var locationManager = CLLocationManager()
  private var datasource: [ [String:Double] ] = []
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    getData()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func addMark(_ coordinates: CLLocationCoordinate2D ) {
    let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 20, longitudinalMeters:20)
    mapView.setRegion(region, animated: true)
    let markPoint = MKPointAnnotation()
    markPoint.coordinate = coordinates
    mapView.addAnnotation(markPoint)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "pinIdentifier"

    var myAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if myAnnotation == nil {

      myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      myAnnotation?.canShowCallout = true

    } else {

      myAnnotation?.annotation = annotation

    }
    
    myAnnotation?.image = UIImage(named: "batman")

    return myAnnotation

  }
  
  private func marks( _ list: [[ String:Double ]] ) {
    for item in list {
      let long = item["longitud"]!
      let lati = item["latitud"]!
      let coords = CLLocationCoordinate2D(latitude: lati, longitude: long)
      addMark(coords)
    }
  }
  
  private func getData() {
    let url = "http://janzelaznog.com/DDAM/iOS/BatmanLocations.json"
    AF.request(url, headers: nil).responseJSON { response in
      if let data = response.value as? [ [ String: Double ] ] {
        self.datasource = data
        self.marks(data)
      }
    }
  }
}

