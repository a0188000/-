//
//  KeyboardHandle.swift
//  HelloMyKeyboard
//
//  Created by EVERTRUST on 2017/10/31.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

import UIKit

let keyboardHandle = KeyboardHandle()

final class KeyboardHandle {
    fileprivate var _enable = true
    var isEnable: Bool {
        get {
            return _enable
        } set {
            _enable = newValue
            if newValue {
                NotificationCenter.default.removeObserver(self)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    fileprivate init() {}
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let topVC = UIApplication.topViewController() else { return }
        guard let animationOption = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else { return }
        guard let duration: Double = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt(animationOption<<16))
        if let first = UIResponder.firstResponder() as? UIView {
            let rect = first.convert(CGPoint(x: 0, y: first.frame.height), to: topVC.view).y
            let offsetX = rect + keyboardFrame.cgRectValue.height - topVC.view.frame.height + 20
            if offsetX > 0 {
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    topVC.view.frame = CGRect(x: 0.0, y: -offsetX, width: topVC.view.frame.width, height: topVC.view.frame.height)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    topVC.view.frame = CGRect(x: 0, y: 0, width: topVC.view.frame.width, height: topVC.view.frame.height)
                }, completion: nil)
            }
            
        }
    }
    
    @objc func keyboardWillhide(_ notification: Notification) {
        guard let topVC = UIApplication.topViewController() else { return }
        guard let animationOption = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else { return }
        guard let duration: Double = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt(animationOption<<16))
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            topVC.view.frame = CGRect(x: 0, y: 0, width: topVC.view.frame.width, height: topVC.view.frame.height)
        }, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    public class func firstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFristResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    func findFristResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}
