

import Foundation
import Moya

enum ExistThunService {
    case existThunRequest(lightId: Int)
}

extension ExistThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .existThunRequest(let lightId):
            return "\(APIConstants.getExistThun)" + "/\(lightId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .existThunRequest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .existThunRequest:
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


