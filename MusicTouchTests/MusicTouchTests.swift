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
		
		XCTAssertFalse(ds.isDataLoaded())
		
		fillPlaylists(dataStore: ds)
		XCTAssertEqual(ds.playlistList().count, 3)
		
		ds.newPlaylist(persistentID: 4, playlist: "Playlist 4")
		XCTAssertEqual(ds.playlistList().count, 4)
		
		XCTAssertEqual(ds.playlistList()[0].name, "Playlist 1")
		XCTAssertEqual(ds.playlistList()[1].name, "Playlist 2")
		XCTAssertEqual(ds.playlistList()[2].name, "Playlist 3")
		XCTAssertEqual(ds.playlistList()[3].name, "Playlist 4")
		
		XCTAssertTrue(ds.isDataLoaded())
    }
	
	func testArtistData() {
		let ds = DataStoreMock()
		
		XCTAssertFalse(ds.isDataLoaded())

		ds.newArtist(persistentID: 1, artistPermanentID: 1, artist: "Artist 1")
		ds.newArtist(persistentID: 2, artistPermanentID: 2, artist: "Artist 2")
		ds.newArtist(persistentID: 3, artistPermanentID: 3, artist: "Artist 3")
		XCTAssertEqual(ds.artistList().count, 3)
		
		ds.newArtist(persistentID: 4, artistPermanentID: 4, artist: "Artist 4")
		XCTAssertEqual(ds.artistList().count, 4)
		
		XCTAssertEqual(ds.artistList()[0].name, "Artist 1")
		XCTAssertEqual(ds.artistList()[1].name, "Artist 2")
		XCTAssertEqual(ds.artistList()[2].name, "Artist 3")
		XCTAssertEqual(ds.artistList()[3].name, "Artist 4")
		
		XCTAssertTrue(ds.isDataLoaded())
	}

	func testAlbumData() {
		let ds = DataStoreMock()
		
		XCTAssertFalse(ds.isDataLoaded())
		
		fillAlbums(dataStore: ds)

		XCTAssertEqual(ds.albumList().count, 4)
		
		let artist = ds.artistList().last!
		let newAlbum = MTAlbumData(persistentID: 5, artistName: artist.name, albumTitle: "Album 5", mediaLibrary: ds)
		artist.add(album: newAlbum)
		XCTAssertEqual(ds.albumList().count, 5)
		
		XCTAssertEqual(ds.albumList()[0].albumTitle, "Album 1")
		XCTAssertEqual(ds.albumList()[0].artistName, "Artist 1")
		XCTAssertEqual(ds.albumList()[1].albumTitle, "Album 2")
		XCTAssertEqual(ds.albumList()[1].artistName, "Artist 1")
		XCTAssertEqual(ds.albumList()[2].albumTitle, "Album 3")
		XCTAssertEqual(ds.albumList()[2].artistName, "Artist 3")
		XCTAssertEqual(ds.albumList()[3].albumTitle, "Album 4")
		XCTAssertEqual(ds.albumList()[3].artistName, "Artist 3")
		
		XCTAssertTrue(ds.isDataLoaded())
	}

	func testPlaylistController() {
		let ds = DataStoreMock()
		let controller = PlaylistController(tabBarController: nil, viewController: nil, dataStore: ds, player: nil)

		XCTAssertFalse(ds.isDataLoaded())

		fillPlaylists(dataStore: ds)
		controller.initializeList()
		
		XCTAssertTrue(ds.isDataLoaded())
		
		XCTAssertEqual(controller.getItem(byIndex: 0)?.name, "Playlist 1")
		
		XCTAssertTrue(controller.indexWithinBounds(index: 2))
		XCTAssertFalse(controller.indexWithinBounds(index: 3))
		
		XCTAssertEqual(controller.numberOfItems(), 3)
	}
	
	func testArtistController() {
		let ds = DataStoreMock()
		let controller = ArtistController(tabBarController: nil, viewController: nil, dataStore: ds, player: nil)
		
		XCTAssertFalse(ds.isDataLoaded())
		fillArtists(dataStore: ds)
		controller.initializeList()
		
		XCTAssertTrue(ds.isDataLoaded())
		
		XCTAssertEqual(controller.getItem(byIndex: 0)?.name, "Artist 1")

		XCTAssertTrue(controller.indexWithinBounds(index: 2))
		XCTAssertFalse(controller.indexWithinBounds(index: 3))
		
		XCTAssertEqual(controller.numberOfItems(), 3)
	}

	func testAlbumController() {
		let ds = DataStoreMock()
		let controller = AlbumController(tabBarController: nil, viewController: nil, dataStore: ds, player: nil)

		XCTAssertFalse(ds.isDataLoaded())
		fillAlbums(dataStore: ds)
		controller.initializeList()
		
		XCTAssertTrue(ds.isDataLoaded())
		
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

extension MusicTouchTests {
	func fillPlaylists(dataStore: DataStoreProtocol) {
		dataStore.add(playlist: MTPlaylistData(persistentID: 1, name: "Playlist 1", mediaLibrary: dataStore))
		dataStore.add(playlist: MTPlaylistData(persistentID: 2, name: "Playlist 2", mediaLibrary: dataStore))
		dataStore.add(playlist: MTPlaylistData(persistentID: 3, name: "Playlist 3", mediaLibrary: dataStore))
	}
	
	func fillArtists(dataStore: DataStoreProtocol) {
		dataStore.add(artist: MTArtistData(persistentID: 1, name: "Artist 1", mediaLibrary: dataStore))
		dataStore.add(artist: MTArtistData(persistentID: 2, name: "Artist 2", mediaLibrary: dataStore))
		dataStore.add(artist: MTArtistData(persistentID: 3, name: "Artist 3", mediaLibrary: dataStore))
	}
	
	func fillAlbums(dataStore: DataStoreProtocol) {
		fillArtists(dataStore: dataStore)
		
		var artist = dataStore.artistList().first!
		artist.add(album: MTAlbumData(persistentID: 1, artistName: artist.name, albumTitle: "Album 1", mediaLibrary: dataStore))
		artist.add(album: MTAlbumData(persistentID: 2, artistName: artist.name, albumTitle: "Album 2", mediaLibrary: dataStore))
		
		artist = dataStore.artistList().last!
		artist.add(album: MTAlbumData(persistentID: 3, artistName: artist.name, albumTitle: "Album 3", mediaLibrary: dataStore))
		artist.add(album: MTAlbumData(persistentID: 4, artistName: artist.name, albumTitle: "Album 4", mediaLibrary: dataStore))
	}
	
}
