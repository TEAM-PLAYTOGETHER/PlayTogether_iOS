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
                    guard let data = responseData?.message else { return }
                    
                    let isExist = data == "해당 번개에 참여중이 아닙니다." ? false : true
                    self?.isExistThun = isExist
                    print("여기 나오나 확인", isExist)
                    completion(isExist)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
