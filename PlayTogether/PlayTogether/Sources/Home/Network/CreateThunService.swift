//
//  CreateThunService.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/10.
//

import Moya
import UIKit

enum CreateThunService {
    case createThunRequest(images: [UIImage]? = nil, params: [String: String])
}

extension CreateThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .createThunRequest(_, _):
            return APIConstants.createThun + "/\(APIConstants.crewID)"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case let .createThunRequest(images, params):
            var formData = [MultipartFormData]()
            if let images = images {
                for i in 0..<images.count {
                    guard let imageData = images[i].jpegData(compressionQuality: 1.0)
                    else { continue }
                    formData.append(MultipartFormData(
                        provider: .data(imageData),
                        name: "image",
                        fileName: "\(images[i]).jpeg",
                        mimeType: "image/jpeg"
                    ))
                }
            }
            for (key, value) in params {
                guard let data = value.data(using: .utf8) else { continue }
                formData.append(MultipartFormData(provider: .data(data), name: key))
            }
            return .uploadMultipart(formData)
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
