import Foundation
import Moya
import RxSwift

final class ExistThunViewModel {
    private lazy var disposeBag = DisposeBag()
    var isExistThun = false
    
    func getExistThun(lightId: Int, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<ExistThunService>()
        provider.rx.request(.existThunRequest(lightId: lightId))
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(ExistThunResponse.self)
                    guard let data = responseData else { return }
                    let isExist = data.message == "해당 번개에 참여중이 아닙니다." ? false : true
                    self?.isExistThun = isExist
                    completion(self?.isExistThun ?? false)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getExistThunOrganizer(lightId: Int, completion: @escaping (String) -> Void) {
        let provider = MoyaProvider<ExistThunService>()
        provider.rx.request(.existThunRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(ExistThunResponse.self)
                    guard let isOrganizerData = responseData?.data.isOrganizer else { return }
                    guard let isEnteredData = responseData?.data.isEntered else { return }
                    switch isEnteredData {
                    case true:
                        if isOrganizerData == true {
                            completion("내가 만든 번개에 참여중 입니다.")
                        } else {
                            completion("내가 만든 번개는 아니지만, 해당 번개에 참여중입니다.")
                        }
                    case false:
                        completion("해당 번개에 참여중이 아닙니다.")
                    }
//                    completion(data ? true : false)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
