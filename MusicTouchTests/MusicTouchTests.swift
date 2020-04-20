//
//  MusicTouchTests.swift
//  MusicTouchTests
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import XCTest
import MediaPlayer
@testable import MusicTouch

class MusicTouchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPlaylistData() {
		let ds = DataStoreMock()
		
		XCTAssertEqual(ds.playlistList().count, 3)
		
		XCTAssertEqual(ds.playlistList()[0].name, "Playlist 1")
		XCTAssertEqual(ds.playlistList()[1].name, "Playlist 2")
		XCTAssertEqual(ds.playlistList()[2].name, "Playlist 3")
    }
	
	func testArtistData() {
		let ds = DataStoreMock()
		
		XCTAssertEqual(ds.artistList().count, 3)
		
		XCTAssertEqual(ds.artistList()[0].name, "Artist 1")
		XCTAssertEqual(ds.artistList()[1].name, "Artist 2")
		XCTAssertEqual(ds.artistList()[2].name, "Artist 3")
	}

	func testAlbumData() {
		let ds = DataStoreMock()
		
		let albumList = ds.albumList().sorted { $0.persistentID < $1.persistentID }
		
		XCTAssertEqual(albumList.count, 4)
		
		XCTAssertEqual(albumList[0].persistentID, 7)
		XCTAssertEqual(albumList[0].albumTitle, "Album 1")
		XCTAssertEqual(albumList[0].artistName, "Artist 1")
		
		XCTAssertEqual(albumList[1].persistentID, 8)
		XCTAssertEqual(albumList[1].albumTitle, "Album 2")
		XCTAssertEqual(albumList[1].artistName, "Artist 1")
		
		XCTAssertEqual(albumList[2].persistentID, 9)
		XCTAssertEqual(albumList[2].albumTitle, "Album 3")
		XCTAssertEqual(albumList[2].artistName, "Artist 3")
		
		XCTAssertEqual(albumList[3].persistentID, 10)
		XCTAssertEqual(albumList[3].albumTitle, "Album 4")
		XCTAssertEqual(albumList[3].artistName, "Artist 3")
	}

	func testPlaylistController() {
		let ds = DataStoreMock()
		let controller = PlaylistController(tabBarController: nil, dataStore: ds, player: nil)

		XCTAssertEqual(controller.getItem(byIndex: 0)?.name, "Playlist 1")
		
		XCTAssertTrue(controller.indexWithinBounds(index: 2))
		XCTAssertFalse(controller.indexWithinBounds(index: 3))
		
		XCTAssertEqual(controller.numberOfItems(), 3)
	}
	
	func testArtistController() {
		let ds = DataStoreMock()
		let controller = ArtistController(tabBarController: nil, dataStore: ds, player: nil)
		
		XCTAssertEqual(controller.getItem(byIndex: 0)?.name, "Artist 1")

		XCTAssertTrue(controller.indexWithinBounds(index: 2))
		XCTAssertFalse(controller.indexWithinBounds(index: 3))
		
		XCTAssertEqual(controller.numberOfItems(), 3)
	}

	func testAlbumController() {
		let ds = DataStoreMock()
		let controller = AlbumController(tabBarController: nil, dataStore: ds, player: nil)

		XCTAssertEqual(controller.getItem(byIndex: 0)?.albumTitle, "Album 1")
		
		XCTAssertTrue(controller.indexWithinBounds(index: 3))
		XCTAssertFalse(controller.indexWithinBounds(index: 4))
		
		XCTAssertEqual(controller.numberOfItems(), 4)
	}
	
	
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
