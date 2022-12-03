//
//  BaseViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit
import SnapKit
import Then

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        setupViews()
        setupLayouts()
        setupBinding()
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
    
    func setupLayouts() {}
    
    func setupBinding() {}
}

extension BaseViewController {
    func showToast(_ message: String) {
        let screenBounds = UIScreen.main.bounds
        let toastLabel = UILabel(
            frame: CGRect(x: screenBounds.width / 2 - 108.5,
                          y: screenBounds.height - 112,
                          width: 217 * (screenBounds.width / 375),
                          height: 38 * (screenBounds.height / 812))
        ).then() {
            $0.text = message
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .pretendardMedium(size: 14)
            $0.backgroundColor = .black.withAlphaComponent(0.7)
            $0.alpha = 1.0
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.clipsToBounds = true
        }
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.5,
                       delay: 0.2,
                       options: .curveEaseOut,
                       animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
