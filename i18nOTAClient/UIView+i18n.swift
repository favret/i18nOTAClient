//
//  UIView+i18n.swift
//  SaveKiti18n
//
//  Created by favre on 20/10/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

final class i18n_dispatch {
  static let shared = i18n_dispatch()
  private var token = 0
  func once(handler: (Void) -> Void) {
    guard token == 0
      else { return }
  
    handler()
    token = 1
  }
  
  static func Once(handler: (Void) -> Void) {
    i18n_dispatch.shared.once(handler: handler)
  }
}

extension UIView {
  open override class func initialize() {
    i18n_dispatch.Once {
      let originalSelector = #selector(NSObject.awakeFromNib)
      let swizzledSelector = #selector(UIView.i18n_awakeFromNib)
      
      let originalMethod = class_getInstanceMethod(self, originalSelector)
      let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
      
      let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
      
      if didAddMethod {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }
  
  func i18n_awakeFromNib() {
    self.i18n_awakeFromNib()
    print("i18n_awakeFromNib: \(self)")
    self.localized(object: self)
    
  }
}
