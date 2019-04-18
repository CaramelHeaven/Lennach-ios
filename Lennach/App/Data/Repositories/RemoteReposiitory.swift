//
//  RemoteReposiitory.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation
import Alamofire

enum AlamofireRouter: URLRequestConvertible {

    case getThreadsByBoard(_: String, _: String)

    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .getThreadsByBoard(board, page):
                return ("", ["/": board, "b": page])
            }
        }()

        let url = try "https://2ch.hk/".asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        print("url request: \(urlRequest)")

        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }


}

class RemoteRepository {
    static let instance = RemoteRepository()
    
    let boardMapper = BoardMapper()

    private init() { }

    func getThreadsByBoard(boardName name: String, page: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        let url = "https://2ch.hk/" + name + "/" + page + ".json"

        Alamofire.request(url).responseJSON { (response) in
            do {
                let data = try JSONDecoder().decode(BoardResponse.self, from: response.data!)
                let board = self.boardMapper.mapResponseToBoardUseCase(response: data)
                
                completion(true, board, nil)
            } catch {
                completion(false, nil, error)
                print(error)
            }
        }
    }

}
