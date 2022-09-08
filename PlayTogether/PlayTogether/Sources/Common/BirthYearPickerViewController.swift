//
//  BirthYearPickerViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/05.
//

import UIKit
import RxSwift

class BirthYearPickerViewController: UIViewController {
    private lazy var disposeBag = DisposeBag()
    
    private lazy var yearPickerView = UIPickerView().then {
        $0.backgroundColor = .white
        $0.tintColor = .clear
    }
    
    private let doneToolBar = UIToolbar()
    
    private let doneBarButton = UIBarButtonItem.init(title: "완료", style: .plain, target: self, action: nil)
    
    private var yearList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupYearData()
    }
}

private extension BirthYearPickerViewController {
    func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(yearPickerView)
        
        setupLayout()
        setupBinding()
    }
    
    func setupLayout() {
        yearPickerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(212 * (UIScreen.main.bounds.height / 812))
        }
    }
    
    func setupBinding() {
        doneBarButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                print("DEBUG: button tapped")
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func setupYearData() {
        for i in 1900...2022 {
            yearList.append(i)
        }
        
        _ = Observable.just(yearList)
            .bind(to: yearPickerView.rx.itemTitles) { _, item in
                return "\(item)"
            }
        
        setupPickerView()
    }
    
    func setupPickerView() {
        guard let defaultIndex = yearList.firstIndex(of: 2000) else { return }
        yearPickerView.selectRow(defaultIndex, inComponent: 0, animated: true)
        
        doneToolBar.sizeToFit()
        doneToolBar.items = [doneBarButton]
        
//        yearPickerView.a
    }
}
