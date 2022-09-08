

import Foundation
import Moya

enum ExistLikeThunService {
    case existLikeThunRequest(lightId: Int)
}

extension ExistLikeThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .existLikeThunRequest(let lightId):
            return APIConstants.getExistLikeThun + "/\(lightId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .existLikeThunRequest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .existLikeThunRequest:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let token = APIConstants.token
        return [
            "Content-Type": "application/json",
            "Authorization": token
        ]
    }
}

