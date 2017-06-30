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
    
    var realm: Realm!
    var subject: SourceInteractor!
    
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
        realm = createInMemoryRealm(with: createMockSources())
        subject = SourceInteractor(realm: realm)
    }
    
    func test_AddSource() {
        let testExpectation = expectation(description: "Should return all favorites")
        
        cleanRealm(realm)
        
        let mockSources = createMockSources()
        subject.add(observable: Observable.from(mockSources))
        
        subject.fetchSources()
            .subscribe(onNext: { results in
                XCTAssertEqual(results.count, 5)
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_FetchSources() {
        let testExpectation = expectation(description: "Should return all favorites")
        
        subject.fetchSources()
            .subscribe(onNext: { results in
                XCTAssertEqual(results.count, 5)
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_CheckIfSourceIdIsFavorite() {
        let successTestExpectation = expectation(description: "SourceId should be favorite")
        let emptyTestExpectation = expectation(description: "Should be empty")

        let newFavorite = SourceObject()
        newFavorite.id = "a"
        newFavorite.isFavorite = true
        
        cleanRealm(realm)
        
        try! realm.write {
            realm.add(newFavorite, update: true)
        }
        
        subject.isFavorite("a")
            .subscribe(onNext: { results in
                XCTAssertEqual(results.count, 1)
                successTestExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)

        subject.isFavorite("z")
            .subscribe(onNext: { results in
                XCTAssert(results.isEmpty)
                emptyTestExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_FavoriteSourceId() {
        let testExpectation = expectation(description: "SourceId should be favorite")
        let newFavoriteSourceId = "a"

        subject.setFavorite(for: newFavoriteSourceId, isFavorite: true)

        subject.isFavorite(newFavoriteSourceId)
            .subscribe(onNext: { results in
                XCTAssertEqual(results[0].id, newFavoriteSourceId)
                testExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }


    
//    func test_GetFavoriteSources() {
//        let testExpectation = expectation(description: "Should return all favorites")
//        
//        let realm = createInMemoryRealm(with: favoriteSources)
//        let subject = SourceInteractor(realm: realm)
//        
//        subject.fetchFavorites()
//            .subscribe(onNext: { results in
//                XCTAssertEqual(results[0], self.favoriteSources[0])
//                XCTAssertEqual(results[1], self.favoriteSources[1])
//                XCTAssertEqual(results[2], self.favoriteSources[2])
//                testExpectation.fulfill()
//            }, onError: { _ in
//                XCTFail("Should not error")
//            })
//            .addDisposableTo(disposeBag)
//        
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//

//    
//    func test_UnfavoriteSourceId() {
//        let testExpectation = expectation(description: "Unfavorite should remove sourceId from Realm")
//        
//        let realm = createInMemoryRealm(with: favoriteSources)
//        let subject = SourceInteractor(realm: realm)
//        
//        subject.unfavorite(sourceId: "Test1")
//            
//        subject.isFavorite("Test1")
//            .subscribe(onNext: { results in
//                XCTAssert(results.isEmpty)
//                testExpectation.fulfill()
//            })
//            .addDisposableTo(disposeBag)
//        
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
    
    func cleanRealm(_ realm: Realm) {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func createInMemoryRealm(with sources: [NewsAPISource]? = nil) -> Realm {
        var configuration = Realm.Configuration()
        configuration.inMemoryIdentifier = UUID().uuidString
        
        let inMemoryRealm = try! Realm(configuration: configuration)
        
        cleanRealm(inMemoryRealm)
        
        if let sources = sources {
            try! inMemoryRealm.write {
                _ = sources.map { inMemoryRealm.add(SourceObject(source: $0)) }
            }
        }
        
        return inMemoryRealm
    }
}
