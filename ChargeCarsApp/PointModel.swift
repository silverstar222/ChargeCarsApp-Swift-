//
//  PointModel.swift
//  ChargeCarsApp
//
//  Created by SilverStar on 4/25/17.
//  Copyright © 2017 SilverStar. All rights reserved.
//

import Foundation

class PModel {
  var titelPoint:String
  var lon:Double?
  var lat:Double?
  
  init(_ titelPoint: String, _ lon: Double, _ lat: Double ) {
    self.titelPoint = titelPoint
    self.lon = lon
    self.lat = lat
  }
}
