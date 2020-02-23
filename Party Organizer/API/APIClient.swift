//
//  APIClient.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/22/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

struct APIClient {
    static let shared = APIClient()
    
    let session = URLSession.shared
    let bag = DisposeBag()
    
    private let baseURL = "http://api-coin.quantox.tech/"
    private let membersEndpoint = "profiles.json"
    
    //MARK: Get Members from api and bind to members property
    func getMembers() {
        bypassURLAuthentication()
        
        RxAlamofire.requestData(.get, baseURL + membersEndpoint)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .expectingObject(ofType: Profiles.self)
            .subscribe(onNext: { result in
                switch result {
                case let .success(loginResponse):
                    guard let profiles = loginResponse.profiles else { return }
                    Members.allMembers.onNext(profiles)
                    print("Uspelo je")
                case let .failure(err):
                    print(err.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    //MARK: Function that bypasses unsafe http servers
    func bypassURLAuthentication() {
        let manager = Alamofire.SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
}
