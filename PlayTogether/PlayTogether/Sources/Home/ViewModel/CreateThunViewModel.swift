//
//  CreateThunViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/29.
//

import UIKit

import Moya
import RxMoya
import RxSwift
import RxRelay

final class CreateThunViewModel {
    private lazy var disposeBag = DisposeBag()
    private lazy var parameter = [String: String]()
    var titleInputRelay = BehaviorRelay<String>.init(value: .init())
    var categoryInputRelay = BehaviorRelay<String>.init(value: .init())
    var dateInputRelay = BehaviorRelay<String>.init(value: .init())
    var timeInputRelay = BehaviorRelay<String>.init(value: .init())
    var placeInputRelay = BehaviorRelay<String>.init(value: .init())
    var memberCountInputRelay = BehaviorRelay<String>.init(value: .init())
    var imageInputRelay = BehaviorRelay<[UIImage]>.init(value: .init())
    var descriptionInputRelay = BehaviorRelay<String>.init(value: .init())
    
    func isCreateEnable() -> Observable<Bool> {
        let output = Observable.combineLatest(
            titleInputRelay,
            categoryInputRelay,
            dateInputRelay,
            timeInputRelay,
            placeInputRelay,
            memberCountInputRelay,
            descriptionInputRelay
        ).map {
            return !$0.0.isEmpty
            && !$0.1.isEmpty
            && (!$0.2.isEmpty || $0.2 == "unlock")
            && (!$0.3.isEmpty || $0.3 == "unlock")
            && (!$0.4.isEmpty || $0.4 == "unlock")
            && (!$0.5.isEmpty || $0.5 == "unlock")
            && $0.6 != "만나서 무엇을 할지, 위치 등을 구체적으로 적어주세요.\n200자까지 쓸 수 있어요."
        }
        
        return output
    }
    
    func createThunRequest(completion: @escaping ([CreateThun]) -> Void) {
        setupParameter()
        
        let provider = MoyaProvider<CreateThunService>()
        provider.rx.request(.createThunRequest(
            images: imageInputRelay.value.compactMap { $0 },
            params: parameter)
        ).subscribe { result in
            switch result {
            case let .success(response):
                let responseData = try? response.map(CreateThunResponse.self)
                guard let data = responseData?.data else { return }
                completion(data)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}

private extension CreateThunViewModel {
    func setupParameter() {
        let keys = ["category", "title", "date", "place", "peopleCnt", "description", "time"]
        
        self.parameter[keys[0]] = categoryInputRelay.value
        self.parameter[keys[1]] = titleInputRelay.value
        
        if !dateInputRelay.value.isEmpty && dateInputRelay.value != "unlock" {
            self.parameter[keys[2]] = self.convertDate(dateInputRelay.value)
        }
        
        if !placeInputRelay.value.isEmpty && placeInputRelay.value != "unlock" {
            self.parameter[keys[3]] = placeInputRelay.value
            
        }
        
        if !memberCountInputRelay.value.isEmpty && memberCountInputRelay.value != "unlock" {
            self.parameter[keys[4]] = memberCountInputRelay.value
        }
        
        self.parameter[keys[5]] = descriptionInputRelay.value
        
        if !timeInputRelay.value.isEmpty && timeInputRelay.value != "unlock" {
            self.parameter[keys[6]] = timeInputRelay.value
        }
    }
    
    func convertDate(_ dateString: String) -> String {
        return dateString.replacingOccurrences(of: ".", with: "-")
    }
}
