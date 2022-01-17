//
//  Array Extension.swift
//  My_Bookself_Application
//
//  Created by sungwook on 1/17/22.
//

import Foundation


extension Array {
  
  /// `func sorted()` according to keyPaht of `Element`
  /// - Parameters:
  ///   - keyPath: taking keyPath
  ///   - compareClosure: comparing closure like < or >
  func sorted<Value: Comparable>(keyPath: KeyPath<Element, Value>, by compareClosure: (Value, Value) -> Bool) -> [Element] {
    
    sorted {
      
      compareClosure($0[keyPath: keyPath], $1[keyPath: keyPath])
    }
  }
  
  
  /// `func sort()` according to keyPaht of `Element`
  ///  ** CAVEAT **
  /// Mutating itself
  /// - Parameters:
  ///   - keyPath: taking keyPath
  ///   - compareClosure: comparing closure like < or >
  mutating func sort<Value>(keyPath: KeyPath<Element, Value>, by compareClosure: (Value, Value) -> Bool) {
    
    sort {
      
      compareClosure($0[keyPath: keyPath], $1[keyPath: keyPath])
    }
  }
  
  
  /// get the max `Value` from `Element` through the KeyPath.
  func max<Value: Comparable>(keyPath: KeyPath<Element, Value>) -> Value? {
    
    let values_obtained_through_the_keyPath_from_the_Elements = self.map {
      
      $0[keyPath: keyPath]
    }
    
    return values_obtained_through_the_keyPath_from_the_Elements.max()
  }
  
  
  /// get the min `Value` from `Element` through the KeyPath.
  func min<Value: Comparable>(keyPath: KeyPath<Element, Value>) -> Value? {
    
    let values_obtained_through_the_keyPath_from_the_Elements = self.map {
      
      $0[keyPath: keyPath]
    }
    
    return values_obtained_through_the_keyPath_from_the_Elements.min()
  }
}
