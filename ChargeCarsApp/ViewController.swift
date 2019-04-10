//
//  ViewController.swift
//  ChargeCarsApp
//
//  Created by SilverStar on 4/25/17.
//  Copyright © 2017 SilverStar. All rights reserved.
//

import UIKit
import AEXML
import GoogleMaps

class ViewController: UIViewController {

  @IBOutlet weak var gMapView: GMSMapView!
  @IBOutlet weak var myLocation: UIButton!
  @IBOutlet weak var myLocationViewImage: UIImageView!
  @IBOutlet weak var segmentControlTypeMap: UISegmentedControl!
  var locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getDataFromServer()
    
    myLocationViewImage.layer.cornerRadius = myLocationViewImage.frame.size.height/2
    myLocationViewImage.clipsToBounds = true
    segmentControlTypeMap.layer.cornerRadius = 4
    gMapView.delegate = self as GMSMapViewDelegate
    let camera = GMSCameraPosition.camera(withLatitude: Double(50.4558046) , longitude: Double(30.5126752 ), zoom: 4.8)
    gMapView?.animate(to: camera)
    gMapView.isMyLocationEnabled = true
    self.locationManager.delegate = self
    self.locationManager.startUpdatingLocation()
    getDataFronXML { result in
    for location in result {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.lat! , longitude: location.lon!)
        marker.title = location.titelPoint
        marker.icon = UIImage(named: markerImage)
        marker.map = self.gMapView
      }
    }
  }
  
  @IBAction func myLocationAction(_ sender: Any) {

    if gMapView.myLocation != nil {
      let camera = GMSCameraPosition.camera(withLatitude: (gMapView.myLocation?.coordinate.latitude)!, longitude: (gMapView.myLocation?.coordinate.longitude)!, zoom: 12.0)
      self.gMapView?.animate(to: camera)
    } else {
       let alert = UIAlertController(title: "Геолокация", message: "Разрешите приложению доступ к вашей геолокации.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  @IBAction func segControlTypeMapAction(_ sender: Any) {
    if segmentControlTypeMap.selectedSegmentIndex == 0 {
      gMapView.mapType = .normal
    } else {
      gMapView.mapType = .hybrid
    }

  }
  
  func getDataFromServer() {
    getDataFromJson { result in
      print(result)
    }
  }
}
 
extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
    self.gMapView?.animate(to: camera)
    self.locationManager.stopUpdatingLocation()
  }
}

extension ViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    
    let alertRoute = UIAlertController(title: "Маршрут", message: "Построить маршрут?", preferredStyle: .alert)
    alertRoute.addAction(UIAlertAction(title: "Построить", style: .default , handler: { (action) in
      
      if (UIApplication.shared.canOpenURL(URL(string:comgooglemaps)!)) {
        UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=\(mapView.myLocation!.coordinate.latitude),\(mapView.myLocation!.coordinate.longitude)&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")!)
      } else {
        print("Can't use comgooglemaps://");
        UIApplication.shared.openURL(URL(string: "http://maps.apple.com/?saddr=\(mapView.myLocation!.coordinate.latitude),\(mapView.myLocation!.coordinate.longitude)&daddr=\(marker.position.latitude),\(marker.position.longitude)"
          )!)
      }
      
    }))
    alertRoute.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    self.present(alertRoute, animated: true, completion: nil)
    
  }
  
  func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    let infoWindow = Bundle.main.loadNibNamed(infoWindowNib, owner: self, options: nil)?.first as! InfoView
    infoWindow.layer.cornerRadius = 3.0
    infoWindow.imageViewMarker.image = UIImage(named: infoWindowImage)
    infoWindow.textLabel.text = marker.title
    return infoWindow
  }
}


