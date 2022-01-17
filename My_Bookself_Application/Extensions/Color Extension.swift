//
//  Color Extension.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import UIKit
import SwiftUI


/// convert HEX string to (r, g, b, a) pair
func rgbaValue(hex_string: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {

    var rgbaValue : (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? = nil

    if hex_string.hasPrefix("#") {

        let start = hex_string.index(hex_string.startIndex, offsetBy: 1)
        let hexColor = String(hex_string[start...]) // Swift 4

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {

            rgbaValue = { // start of a closure expression that returns a Vehicle
                switch hexColor.count {
                case 8:

                    return ( r: CGFloat((hexNumber & 0xff000000) >> 24) / 255,
                             g: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
                             b: CGFloat((hexNumber & 0x0000ff00) >> 8)  / 255,
                             a: CGFloat( hexNumber & 0x000000ff)        / 255
                           )
                case 6:

                    return ( r: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
                             g: CGFloat((hexNumber & 0x00ff00) >> 8)  / 255,
                             b: CGFloat((hexNumber & 0x0000ff))       / 255,
                             a: 1.0
                           )
                default:
                    return nil
                }
            }()

        }
    }

    return rgbaValue
}


extension Color {

  init?(hex_string: String) {
    
    let rgbaValue = rgbaValue(hex_string: hex_string)
    
    guard rgbaValue != nil else {
      
      return nil
    }
    
    self.init(
      .sRGB,
      red:     Double(rgbaValue!.r),
      green:   Double(rgbaValue!.g),
      blue:    Double(rgbaValue!.b),
      opacity: Double(rgbaValue!.a)
    )
    
  }
}



extension UIColor {
  
  public convenience init?(hex_string: String) {
    
    let rgbaValue = rgbaValue(hex_string: hex_string)
    
    guard rgbaValue != nil else {
      
      return nil
    }
    
    self.init(
      red:   rgbaValue!.r,
      green: rgbaValue!.g,
      blue:  rgbaValue!.b,
      alpha: rgbaValue!.a)
    
  }
}


