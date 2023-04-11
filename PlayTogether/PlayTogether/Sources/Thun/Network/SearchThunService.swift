

import Foundation
import Moya

enum SearchThunService {
    case searchThunRequest(pageSize: Int, curpage: Int, search: String, category: String)
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
        case .searchThunRequest(let pageSize, let curpage, let search, let category):
            let params = [
                "pageSize": pageSize,
                "curpage": curpage,
                "search": search,
                "category": category
            ] as [String : Any]
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


