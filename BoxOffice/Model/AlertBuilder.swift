//
//  AlertBuilder.swift
//  BoxOffice
//
//  Created by 조호준 on 2023/12/11.
//

import UIKit

final class AlertBuilder {
    private var title: String?
    private var message: String?
    private var actions: [UIAlertAction] = []
    private var preferredStyle: UIAlertController.Style = .alert
    
    func setTitle(_ title: String) -> Self {
        self.title = title
        
        return self
    }
    
    func setMessage(_ message: String) -> Self {
        self.message = message
        
        return self
    }
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        actions.append(UIAlertAction(title: title, style: style, handler: handler))
        
        return self
    }
    
    func setPreferredStyle(_ preferredStyle: UIAlertController.Style) -> Self {
        self.preferredStyle = preferredStyle
        
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actions.forEach {
            alert.addAction($0)
        }
        
        return alert
    }
}
