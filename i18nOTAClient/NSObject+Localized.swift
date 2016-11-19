//
//  NSObject+Localized.swift
//  protoLocalizableI18N
//
//  Created by favre on 14/10/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import UIKit

extension NSObject {
  
  /**
   */
  func localized(object: AnyObject) {
    i18n.shared.fetchLocalized()
    
    //TODO: make it works and then remove switch
    /* let selector = NSSelectorFromString("localized\(String(object.dynamicType))")
     if respondsToSelector(selector) {
     performSelector(selector, withObject: object)
     }
     */
    do {
      switch object {
      case is UILabel:
        try self .localized(label: object as! UILabel)
        
      case is UIButton:
        try self.localized(button: object as! UIButton)
        
      case is UITextView:
        try self.localized(textView: object as! UITextView)
        
      case is UITextField:
        try self.localized(textfield: object as! UITextField)
        
      case is UITabBarItem:
        try self.localized(tabBarItem: object as! UITabBarItem)
        
      case is UINavigationBar:
        try self.localized(navigationBar: object as! UINavigationBar)
        
      case is UINavigationItem:
        try self.localized(navigationItem: object as! UINavigationItem)
        
      default:()
      }
    }
    catch let error as LocalizedError {
      print("[\(#file):\(#function)] OBJECT:\(object)\nERROR : \(error)")
    }
    catch let error as NSError {
      print("[\(#file):\(#function)] OBJECT:\(object)\nERROR : \(error.localizedDescription)")
    }
  }
  
  /**
   */
  func localized(label:UILabel) throws {
    if let text = label.text {
      label.text = try i18n.localized(key: text)
    }
  }
  
  /**
   */
  func localized(button: UIButton) throws {
    if let titleLabel = button.titleLabel {
      try localized(label: titleLabel)
    }
  }
  
  /**
   */
  func localized(textView: UITextView) throws {
    textView.text = try i18n.localized(key: textView.text)
  }
  
  /**
   */
  func localized(textfield: UITextField) throws {
    if let placeholder = textfield.placeholder {
      textfield.placeholder = try i18n.localized(key: placeholder)
    }
  }
  
  /**
   */
  func localized(tabBarItem: UITabBarItem) throws {
    if let title = tabBarItem.title {
      tabBarItem.title = try i18n.localized(key: title)
    }
  }
  
  /**
   */
  func localized(navigationItem: UINavigationItem) throws {
    if let title = navigationItem.title {
      navigationItem.title = try i18n.localized(key: title)
    }
  }
  
  /**
   */
  func localized(navigationBar: UINavigationBar) throws {
    if let topItem = navigationBar.topItem {
      try localized(navigationItem: topItem)
    }
  }
}
