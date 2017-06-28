//
//  SourceInteractor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/28/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RealmSwift
import NewsAPISwift

@testable import NewsFeedDigest

class SourceInteractorTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!
    var subject: SourceInteractor!
    
    let favoriteSources = [
        FavoriteSource(sourceId: "Test1"),
        FavoriteSource(sourceId: "Test2"),
        FavoriteSource(sourceId: "Test3")
    ]
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
        
        let inMemoryRealm = createInMemoryRealm(with: favoriteSources)
        subject = SourceInteractor(realm: inMemoryRealm)
    }
    
    func test_SourceInteractor_GetFavoriteSources() {
        let testExpectation = expectation(description: "Should return all favorites")
        
        subject.fetchAllFavorites()
            .subscribe(onNext: { results in
                XCTAssertEqual(results[0], self.favoriteSources[0])
                XCTAssertEqual(results[1], self.favoriteSources[1])
                XCTAssertEqual(results[2], self.favoriteSources[2])
                testExpectation.fulfill()
            }, onError: { _ in
                XCTFail("Should not error")
            })            
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func createInMemoryRealm(with favorites: [FavoriteSource]?) -> Realm {
        let inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "SourceInteractorTests"))
        
        try! inMemoryRealm.write {
            _ = favorites.map { inMemoryRealm.add($0) }
        }
        
        return inMemoryRealm
    }
}

extension SourceInteractorTests {
    
    class MockSourceInteractor {
        
    }
    
}
