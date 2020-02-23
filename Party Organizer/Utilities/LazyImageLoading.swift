//
//  LazyImageLoading.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

enum ImageFetchError: Error {
    case anonymousError(message: String?)
}


// MARK: - Fetch as UIImage

extension UIImage {
    
    class func image(from url: URL?) -> Observable<UIImage> {
        return Observable
            .create { o in
                guard let url = url else {
                    o.onCompleted()
                    return Disposables.create()
                }
                
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        o.onNext(value.image)
                        o.onCompleted()
                    case .failure(let error):
                        print("Error: \(error)")
                        o.onError(ImageFetchError.anonymousError(message: error.localizedDescription))
                    }
                }
                return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }
    
}
