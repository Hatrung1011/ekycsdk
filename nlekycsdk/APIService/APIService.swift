//
//  APIService.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func getConfig(requestString: String) -> AnyPublisher<GetConfigResponse, APIError> {
        let request = BaseRequest(funcName: requestString)
        
        return apiClient.post(
            endpoint: "/ekycConfig/",
            parameters: request.dictionary,
            responseType: GetConfigResponse.self
        )
    }
    
    func saveLogData(requestString: String, qtsRequestLog: String, checksum: String) -> AnyPublisher<SaveLogResponse, APIError> {
        let request = BaseRequest(funcName: requestString, qtsRequestLog: qtsRequestLog, checksum: checksum)
        
        return apiClient.post(
            endpoint: "/ekycConfig/",
            parameters: request.dictionary,
            responseType: SaveLogResponse.self
        )
    }
}

// MARK: - Extensions
extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return [:] }
        return dictionary
    }
}
