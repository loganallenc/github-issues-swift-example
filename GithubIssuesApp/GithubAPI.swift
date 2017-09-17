//
//  GithubAPI.swift
//  GithubIssuesApp
//
//  Created by Logan Allen on 9/17/17.
//  Copyright © 2017 Logan Allen. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let GithubProvider = MoyaProvider<GitHub>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum GitHub {
    case issues(String)
}

extension GitHub: TargetType {
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
        case .issues(let repositoryPath):
            return "/repos/\(repositoryPath)/issues"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        return nil
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .requestPlain
    }
    public var sampleData: Data {
        switch self {
        case .issues(let repositoryPath):
            return "[{\"id\": 1, \"title\": \"Title text\", \"body\": \"Body text\" }]".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
