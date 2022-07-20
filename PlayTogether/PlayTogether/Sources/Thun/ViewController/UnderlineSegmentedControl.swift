//
//  UnderlineSegmentedControl.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/20.
//

import UIKit
import SnapKit
import Then

class UnderlineSegmentedControl: UISegmentedControl {
    
    private lazy var underlineView = UIView(frame: CGRect(x: CGFloat(self.selectedSegmentIndex * Int(bounds.size.width/CGFloat(numberOfSegments))), y: bounds.size.height - 3.0, width: bounds.size.width/CGFloat(numberOfSegments), height: 5.0)).then {
        $0.backgroundColor = UIColor.ptGreen
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underlineAnimation()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        backgroundColor = .ptBlack01
        setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func setupViews() {
        self.addSubview(underlineView)
    }
    
    private func underlineAnimation() {
        layer.cornerRadius = 0
        let underlineFinalXPosition = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.1,
            animations: { [self] in
                underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
}
