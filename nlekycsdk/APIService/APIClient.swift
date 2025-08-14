//
//  APIClient.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Alamofire
import Combine
import Foundation

// MARK: - API Configuration
struct APIConfig {
    static var baseURL: String {
        return NLeKYCSdkManager.shared.getBaseURL()
    }

    // Default URLs cho từng môi trường
    static let devBaseURL = "https://sandbox.nganluong.vn/nl35/api"
    static let prodBaseURL = "https://api.nganluong.vn/nl35/api"

    static let timeout: TimeInterval = 30
    static let retryCount = 3
}

// MARK: - API Error Types
enum APIError: Error, LocalizedError {
    case networkError(Error)
    case invalidResponse
    case serverError(Int)
    case decodingError
    case noData
    case unauthorized
    case forbidden
    case notFound
    case validationError(String)

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Lỗi kết nối: \(error.localizedDescription)"
        case .invalidResponse:
            return "Phản hồi không hợp lệ từ server"
        case .serverError(let code):
            return "Lỗi server (HTTP \(code))"
        case .decodingError:
            return "Lỗi xử lý dữ liệu"
        case .noData:
            return "Không có dữ liệu"
        case .unauthorized:
            return "Không có quyền truy cập"
        case .forbidden:
            return "Truy cập bị từ chối"
        case .notFound:
            return "Không tìm thấy tài nguyên"
        case .validationError(let message):
            return "Lỗi xác thực: \(message)"
        }
    }
}

// MARK: - API Response Models
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let error: String?
}

struct EmptyResponse: Codable {}

// MARK: - API Client
class APIClient {
    static let shared = APIClient()

    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConfig.timeout
        configuration.timeoutIntervalForResource = APIConfig.timeout

        self.session = Session(
            configuration: configuration,
        )
    }

    // MARK: - Base Headers
    private func baseHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "*/*",
        ]

        return headers
    }

    // MARK: - HTTP Methods

    /// GET Request
    func get<T: Codable>(
        endpoint: String,
        parameters: Parameters? = nil,
        responseType: T.Type = T.self
    ) -> AnyPublisher<T, APIError> {
        return request(
            method: .get,
            endpoint: endpoint,
            parameters: parameters,
            responseType: responseType
        )
    }

    /// POST Request
    func post<T: Codable>(
        endpoint: String,
        parameters: Parameters? = nil,
        responseType: T.Type = T.self
    ) -> AnyPublisher<T, APIError> {
        return request(
            method: .post,
            endpoint: endpoint,
            parameters: parameters,
            responseType: responseType
        )
    }

    /// PUT Request
    func put<T: Codable>(
        endpoint: String,
        parameters: Parameters? = nil,
        responseType: T.Type = T.self
    ) -> AnyPublisher<T, APIError> {
        return request(
            method: .put,
            endpoint: endpoint,
            parameters: parameters,
            responseType: responseType
        )
    }

    /// DELETE Request
    func delete<T: Codable>(
        endpoint: String,
        parameters: Parameters? = nil,
        responseType: T.Type = T.self
    ) -> AnyPublisher<T, APIError> {
        return request(
            method: .delete,
            endpoint: endpoint,
            parameters: parameters,
            responseType: responseType
        )
    }

    /// Upload File
    func upload<T: Codable>(
        endpoint: String,
        data: Data,
        fileName: String,
        mimeType: String,
        parameters: Parameters? = nil,
        responseType: T.Type = T.self
    ) -> AnyPublisher<T, APIError> {
        let url = APIConfig.baseURL + endpoint

        return Future<T, APIError> { promise in
            self.session.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(
                        data, withName: "file", fileName: fileName, mimeType: mimeType)

                    if let parameters = parameters {
                        for (key, value) in parameters {
                            if let data = "\(value)".data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                },
                to: url,
                headers: self.baseHeaders()
            )
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(self.handleError(error, response: response.response)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Private Methods
    private func request<T: Codable>(
        method: HTTPMethod,
        endpoint: String,
        parameters: Parameters? = nil,
        responseType: T.Type = T.self
    ) -> AnyPublisher<T, APIError> {
        let url = APIConfig.baseURL + endpoint

        return Future<T, APIError> { promise in
            self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: self.baseHeaders()
            )
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(self.handleError(error, response: response.response)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func handleError(_ error: AFError, response: HTTPURLResponse?) -> APIError {
        if let response = response {
            switch response.statusCode {
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 404:
                return .notFound
            case 400...499:
                return .validationError("Client error: \(response.statusCode)")
            case 500...599:
                return .serverError(response.statusCode)
            default:
                return .networkError(error)
            }
        }

        switch error {
        case .responseValidationFailed(_):
            return .invalidResponse
        case .responseSerializationFailed:
            return .decodingError
        default:
            return .networkError(error)
        }
    }
}

// MARK: - API Models
struct BaseRequest: Codable {
    let funcName: String?
    var qtsRequestLog: String?
    var checksum: String?

    enum CodingKeys: String, CodingKey {
        case funcName = "func"
        case qtsRequestLog = "qts_request_log"
        case checksum
    }
}

struct GetConfigResponse: Codable {
    let errorCode: Int
    let errorMessage: String
    let data: ConfigData

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case data
    }
}

struct ConfigData: Codable {
    let baseURL: String
    let appId: String
    let publicKey: String
    let privateKey: String
}

struct SaveLogResponse: Codable {
    let errorCode: Int
    let errorMessage: String?
    let data: EmptyData?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case data
    }
}

struct EmptyData: Codable {
}
