//
//  ImageService.swift
//  Spotify Menubar
//
//  Created by Aurélien Tison on 27/04/2018.
//  Copyright © 2018 Aurélien Tison. All rights reserved.
//

import Alamofire
import AlamofireImage
import Cocoa
import RxAlamofire
import RxCocoa
import RxSwift

public protocol ImageServiceProtocol {
    
    func getImage(url: String) -> Observable<NSImage?>
    
}

public final class ImageService: ImageServiceProtocol {
    
    // MARK: Singleton
    
    public static let shared: ImageServiceProtocol = ImageService()
    
    // MARK: Attributes
    
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    private init() {
        
    }
    
    // MARK: Methods
    
    public func getImage(url: String) -> Observable<NSImage?> {
        
        // Observable
        return Observable.create({ (observer: AnyObserver<NSImage?>) -> Disposable in
            
            // Request
            Alamofire.request(url, method: .get).responseImage(completionHandler: { (response: DataResponse<NSImage>) in
                
                // Next
                observer.onNext(response.result.value)
                
                // Completed
                observer.onCompleted()
                
            })
            
            // Disposable
            return Disposables.create()
            
        })
        
    }
    
}
