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

    func getThreadsByBoard(boardName name: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        let url = baseUrl + name + "/catalog.json"

        Alamofire.request(url).responseJSON { response in
            do {
                let data = try JSONDecoder().decode(BoardResponse.self, from: response.data!)
                let board = self.mainMapper.mapResponseToBoardUseCase(response: data)

                completion(true, board, nil)
            } catch {
                completion(false, nil, error)
                print(error)
            }
        }
    }

    func getCommentsByThread(boardName name: String, threadNum: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        let url = baseUrl + "makaba/mobile.fcgi?task=get_thread&board=" + name + "&thread=" + threadNum + "&post=0"

        Alamofire.request(url).responseJSON { response in
            do {
                let data = try JSONDecoder().decode([ThreadResponse].self, from: response.data!)
                let queue = DispatchQueue(label: "", qos: DispatchQoS.utility, attributes: .concurrent)

                queue.async {
                    let comments = self.mainMapper.mapResponseToThreadCommentsUseCase(response: data)

                    DispatchQueue.main.async {
                        completion(true, comments, nil)
                    }
                }
            } catch {
                completion(false, nil, error)
            }
        }
    }

    func getAllBoards(completion: @escaping (Bool, Any?) -> Void) {
        let url = baseUrl + "makaba/mobile.fcgi?task=get_boards"
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

    func getUpdatingMsgsValueInThread(boardName name: String, threadNum: String, completion: @escaping (Int) -> Void) {
        let url = baseUrl + "makaba/mobile.fcgi?task=get_thread&board=" + name + "&thread=" + threadNum + "&post=0"
        Alamofire.request(url).responseJSON { response in
            do {
                let data = try JSONDecoder().decode([ThreadResponse].self, from: response.data!)
                completion(data.count)
            } catch {
                print("error: \(error)")
            }
        }
    }
}
