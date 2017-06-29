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
    
    let favoriteSources = [
        FavoriteSource(sourceId: "Test1"),
        FavoriteSource(sourceId: "Test2"),
        FavoriteSource(sourceId: "Test3")
    ]
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
    }
    
    func test_GetFavoriteSources() {
        let testExpectation = expectation(description: "Should return all favorites")
        
        let realm = createInMemoryRealm(with: favoriteSources)
        let subject = SourceInteractor(realm: realm)
        
        subject.fetchFavorites()
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
    
    func test_CheckIfSourceIdIsFavorite() {
        let successTestExpectation = expectation(description: "SourceId should be favorite")
        let emptyTestExpectation = expectation(description: "Should be empty")
        
        let realm = createInMemoryRealm(with: favoriteSources)
        let subject = SourceInteractor(realm: realm)
        
        subject.isFavorite("Test1")
            .subscribe(onNext: { results in
                XCTAssertEqual(results[0], self.favoriteSources[0])
                successTestExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        subject.isFavorite("Test5")
            .subscribe(onNext: { results in
                XCTAssert(results.isEmpty)
                emptyTestExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_FavoriteSourceId() {
        let testExpectation = expectation(description: "SourceId should be favorite")
        let newFavoriteSourceId = "Test4"
        
        let realm = createInMemoryRealm(with: favoriteSources)
        let subject = SourceInteractor(realm: realm)
        
        subject.favorite(sourceId: newFavoriteSourceId)                
        
        subject.isFavorite(newFavoriteSourceId)
            .subscribe(onNext: { results in
                XCTAssertEqual(results[0].id, newFavoriteSourceId)
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_UnfavoriteSourceId() {
        let testExpectation = expectation(description: "Unfavorite should remove sourceId from Realm")
        
        let realm = createInMemoryRealm(with: favoriteSources)
        let subject = SourceInteractor(realm: realm)
        
        subject.unfavorite(sourceId: "Test1")
            
        subject.isFavorite("Test1")
            .subscribe(onNext: { results in
                XCTAssert(results.isEmpty)
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func cleanRealm(_ realm: Realm) {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func createInMemoryRealm(with favorites: [FavoriteSource]? = nil) -> Realm {
        var configuration = Realm.Configuration()
        configuration.inMemoryIdentifier = UUID().uuidString
        
        let inMemoryRealm = try! Realm(configuration: configuration)
        
        cleanRealm(inMemoryRealm)
        
        if let favorites = favorites {
            try! inMemoryRealm.write {
                _ = favorites.map { inMemoryRealm.add($0) }
            }
        }
        
        return inMemoryRealm
    }
}
