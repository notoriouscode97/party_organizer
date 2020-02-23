//
//  UIImage+FetchImage.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {

    var imageUrlString: String?
    
    @discardableResult
    func setImage(with url: URL?, urlString: String, placeholder: UIImage? = nil, isAnimated: Bool = false) -> Driver<UIImage?> {
        
        imageUrlString = urlString
        
        image = placeholder
        
        let imageSubject = BehaviorSubject<UIImage?>(value: placeholder)
        
        if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
            image = imageFromCache
            imageSubject.onNext(imageFromCache)
        } else {
            _ = UIImage.image(from: url)
                .subscribe(onNext: { [weak self] (image) in
                    let imageToCache = image
                    if self?.imageUrlString == urlString {
                        isAnimated ? self?.setWithAnimation(image) : (self?.image = image)
                        imageSubject.onNext(imageToCache)
                    }
                    imageCache.setObject(imageToCache, forKey: NSString(string: urlString))
                })
        }
        return imageSubject.asDriver(onErrorJustReturn: placeholder)
    }
}

fileprivate extension UIImageView {
    
    func setWithAnimation(_ image: UIImage) {
        UIView.transition(
            with: self,
            duration: 0.4,
            options: [.transitionCrossDissolve, .curveEaseIn],
            animations: { self.image = image },
            completion: nil
        )
    }
    
}
