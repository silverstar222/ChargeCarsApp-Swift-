//
//  Services.swift
//  ChargeCarsApp
//
//  Created by SilverStar on 4/25/17.
//  Copyright © 2017 SilverStar. All rights reserved.
//

import Foundation
import Alamofire
import AEXML
import SwiftyJSON

 func getDataFronXML(_ complete: @escaping ([PModel])->()) {
  var arrayPoint = [PModel]()
  guard
    let xmlPath = Bundle.main.path(forResource: "Сhargers", ofType: "xml"),
    let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
    else {
      print("resource not found!")
      return
  }
  var options = AEXMLOptions()
  options.parserSettings.shouldProcessNamespaces = false
  options.parserSettings.shouldReportNamespacePrefixes = false
  options.parserSettings.shouldResolveExternalEntities = false
  do {
    let xmlDoc = try AEXMLDocument(xml: data, options: options)
    for object in xmlDoc.root["Document"]["Folder"]["Placemark"].all! {
      let pointModel = PModel("", 0.0, 0.0)
        if object.count != 0 {
        for placemark in object.children {
          if placemark.name == "name" {
            //print(placemark.value!)
            pointModel.titelPoint = placemark.value!
          } else if placemark.name == "Point"{
            for point in placemark.children {
              if point.name == "coordinates" {
                //print(point.value!)
                if let pointValue = point.value {
                  let componentArray = pointValue.components(separatedBy: ",")
                  pointModel.lon = (componentArray[0] as NSString).doubleValue
                  pointModel.lat = (componentArray[1] as NSString).doubleValue
                }
              }
            }
          }
        }
      }
    arrayPoint.append(pointModel)
    }
  complete(arrayPoint)
  } catch {
    print("\(error)")
  }
}

 func getDataFromJson(_ complete: @escaping ([PModel])->()) {
  Alamofire.request(requestData, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil) .responseJSON { (respose) in
    switch respose.result{
    case .success(let value):
      let JsonData = JSON(value)
      print(JsonData)
    case .failure(let error):
      print(error)
    }
    
  }
  

}
