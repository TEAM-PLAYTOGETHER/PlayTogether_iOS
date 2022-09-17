//
//  AddSubwayStationViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Moya
import RxMoya
import Foundation
import CloudKit

final class AddSubwayStationViewModel {
    private lazy var disposeBag = DisposeBag()
    var subwayStationList = PublishSubject<[String]>()
    var lineInfoDict = [String:[String]]()
    private var stationNameArray = [String]()
    
    struct RegularExpressionInput {
        var SubwayStationTitle: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var SubwayStationTitleCheck: Driver<Bool>
    }
    
    init() {
        fetchSubwayStationList()
    }
    
    func RegularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.SubwayStationTitle.map {
            let pattern = "^[ㄱ-ㅎ가-핳0-9\\s]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression) else { return false }
            
            return true
        }.asDriver(onErrorJustReturn: false)
        
        return RegularExpressionOutput(SubwayStationTitleCheck: output)
    }
    
    func fetchSubwayStationList() {
        let provider = MoyaProvider<SelfIntroduceService>()
        provider.rx.request(.searchStationRequeset)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(SubwayStationResponse.self)
                    guard let data = responseData?.searchSTNBySubwayLineInfo.row else { return }
                    
                    for index in 0..<data.count {
                        self?.stationNameArray.append(data[index].stationName)
                        
                        if self?.lineInfoDict[data[index].stationName] == nil {
                            self?.lineInfoDict.updateValue([data[index].lineNum], forKey: data[index].stationName)
                        } else {
                            self?.lineInfoDict[data[index].stationName]!.append(data[index].lineNum)
                        }
                    }
                    
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func filterSubwayStationList(input: RegularExpressionInput) {
        input.SubwayStationTitle
            .subscribe(onNext: { [weak self] in
                let text = $0.lowercased()
                let filterData = self?.stationNameArray.filter { $0.lowercased().hasPrefix(text) }
                self?.subwayStationList.onNext(filterData!.uniqued())
            })
            .disposed(by: disposeBag)
    }
    
    func makeAttributeString(_ targetText: String, _ inputString: String) -> NSMutableAttributedString {
        var textIndex: Int = 0
        let attributeString = NSMutableAttributedString(string: targetText)
        guard let textRange = targetText.range(of: inputString,
                                               options: .caseInsensitive) else { return NSMutableAttributedString(string: "") }
        textIndex = targetText.distance(from: targetText.startIndex, to: textRange.lowerBound)
        attributeString.addAttribute(.foregroundColor,
                                     value: UIColor.link,
                                     range: NSRange(location: textIndex,
                                                    length: inputString.count))
        return attributeString
    }
}
