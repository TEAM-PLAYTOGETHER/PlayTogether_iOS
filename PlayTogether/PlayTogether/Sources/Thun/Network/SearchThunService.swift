

import Foundation
import Moya

enum SearchThunService {
    case searchThunRequest(search: String, category: String)
}

extension SearchThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .searchThunRequest:
            return APIConstants.getSearchThun
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchThunRequest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchThunRequest(let search, let category):
            let params = [
                "search": search,
                "category": category
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
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


