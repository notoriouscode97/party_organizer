//
//  Observable+Map.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/22/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == (HTTPURLResponse, Data){
    
    func expectingObject<T : Decodable>(ofType type: T.Type) -> Observable<ApiResult<T, APIError>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, APIError> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                // otherwise
                return .failure(APIError.serverError)
            }
        }
    }
    
}
