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
    private lazy var underlineView = UIView(frame: CGRect(
        x: CGFloat(self.selectedSegmentIndex * Int(bounds.size.width/CGFloat(numberOfSegments))),
        y: bounds.size.height - 3.0,
        width: bounds.size.width/CGFloat(numberOfSegments),
        height: 5.0)
    ).then {
        $0.backgroundColor = UIColor.ptGreen
        addSubview($0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        removeBackgroundAndDivider()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underlineAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        setDividerImage(
            image,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        backgroundColor = .ptBlack01
    }
    
    private func underlineAnimation() {
        layer.cornerRadius = 0
        let segmentIndex = CGFloat(selectedSegmentIndex)
        let segmentWidth = frame.width / CGFloat(numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.underlineView.frame.origin.x = leadingDistance
            }
        )
    }
}
