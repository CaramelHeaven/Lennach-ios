//
//  RemoteReposiitory.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation
import Alamofire

class RemoteRepository {
    static let instance = RemoteRepository()
    private let mainMapper = RemoteMainMapper()

    private init() { }

    func getThreadsByBoard(boardName name: String, page: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        let url = Constants.baseUrl + name + "/catalog.json"
        print("BOARD URL: \(url)")

        Alamofire.request(url).responseJSON { response in
            do {
                let data = try JSONDecoder().decode(BoardResponse.self, from: response.data!)
                print("DATA BOARD: \(data)")
                let board = self.mainMapper.mapResponseToBoardUseCase(response: data)
                print("usenets count: \(board.usenets.count)")
                completion(true, board, nil)
            } catch {
                completion(false, nil, error)
                print(error)
            }
        }
    }

    func getCommentsByThread(boardName name: String, threadNum: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        let url = Constants.baseUrl + "makaba/mobile.fcgi?task=get_thread&board=" + name + "&thread=" + threadNum + "&post=0"
        print("URL POSTS: \(url)")
        Alamofire.request(url).responseJSON { response in
            do {
                let data = try JSONDecoder().decode([ThreadResponse].self, from: response.data!)
                let comments = self.mainMapper.mapResponseToThreadCommentsUseCase(response: data)

                completion(true, comments, nil)
            } catch {
                completion(false, nil, error)
            }
        }
    }

    func getAllBoards(completion: @escaping (Bool, Any?) -> Void) {
        //http(s)://2ch.hk/makaba/mobile.fcgi?task=get_boards
        let url = Constants.baseUrl + "makaba/mobile.fcgi?task=get_boards"
        Alamofire.request(url).responseJSON { response in
            do {
                let data = try JSONDecoder().decode(AllBoardsResponse.self, from: response.data!)
                let mappedData = self.mainMapper.mapResponseToAllBoards(response: data)

                completion(true, mappedData)
            } catch {
                completion(false, nil)
                print(error)
            }
        }
    }
}
