//
//  CreateMeetViewModelTest.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/29.
//

import RxSwift
import RxCocoa
import Moya

final class CreateMeetViewModel {
    private lazy var disposeBag = DisposeBag()
    
    struct Input {
        var checkMeetingTitle: Observable<Bool>
        var introduceText: Observable<String>
    }
    
    struct RegularExpressionInput {
        var meetingTitleText: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var titleTextCheck: Driver<Bool>
    }
    
    struct nextButtonEnableOutput {
        var nextButtonEnableCheck: Driver<Bool>
    }
    
    struct CreateMeetInput {
        var crewName: String
        var description: String
        var jwt: String
    }
    
    func regularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.meetingTitleText.map {
            let pattern = "^[0-9a-zㅏ-ㅣA-Zㄱ-ㅎ가-힣\\s]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression) else { return false }
            return true
        }.asDriver(onErrorJustReturn: false)
        return RegularExpressionOutput(titleTextCheck: output)
    }
    
    func isNextButtonEnable(input: Input) -> nextButtonEnableOutput {
        let output = Observable.combineLatest(input.checkMeetingTitle, input.introduceText) {
            return $0 && !$1.isEmpty
        }.asDriver(onErrorJustReturn: false)
        return nextButtonEnableOutput(nextButtonEnableCheck: output)
    }
    
    func createMeetRequest(_ input: CreateMeetInput, _ completion: @escaping (CreateMeetResponse) -> (Void)) {
        let provider = MoyaProvider<CreateMeetService>()
        provider.rx.request(.createMeetRequest(
            crewName: input.crewName,
            description: input.description,
            jwt: input.jwt
        )).subscribe{ result in
            switch result {
            case .success(let response):
                guard let responseData = try? response.map(CreateMeetResponse.self) else { return }
                completion(responseData)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}
