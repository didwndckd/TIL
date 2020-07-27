//
//  Model.swift
//  ItunesPlayer
//
//  Created by 양중창 on 2020/02/28.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import Foundation

let testData =
"""
{
"wrapperType": "track",
"kind": "song",
"artistId": 111051,
"collectionId": 268428248,
"trackId": 268428368,
"artistName": "DJ Kayslay & Eminem",
"collectionName": "The Streetsweeper, Vol. 1",
"trackName": "Freestyle (feat. Eminem)",
"collectionCensoredName": "The Streetsweeper, Vol. 1",
"trackCensoredName": "Freestyle (feat. Eminem)",
"collectionArtistId": 2356417,
"collectionArtistName": "DJ Kayslay",
"collectionArtistViewUrl": "https://music.apple.com/kr/artist/dj-kayslay/2356417?uo=4",
"artistViewUrl": "https://music.apple.com/kr/artist/eminem/111051?uo=4",
"collectionViewUrl": "https://music.apple.com/kr/album/freestyle-feat-eminem/268428248?i=268428368&uo=4",
"trackViewUrl": "https://music.apple.com/kr/album/freestyle-feat-eminem/268428248?i=268428368&uo=4",
"previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/Music/bf/0e/75/mzm.sylcimff.aac.p.m4a",
"artworkUrl30": "https://is2-ssl.mzstatic.com/image/thumb/Music/v4/5e/f4/25/5ef425b2-60bc-83d5-3a11-6c1288cde3ac/source/30x30bb.jpg",
"artworkUrl60": "https://is2-ssl.mzstatic.com/image/thumb/Music/v4/5e/f4/25/5ef425b2-60bc-83d5-3a11-6c1288cde3ac/source/60x60bb.jpg",
"artworkUrl100": "https://is2-ssl.mzstatic.com/image/thumb/Music/v4/5e/f4/25/5ef425b2-60bc-83d5-3a11-6c1288cde3ac/source/100x100bb.jpg",
"releaseDate": "2003-04-29T12:00:00Z",
"collectionExplicitness": "explicit",
"trackExplicitness": "explicit",
"discCount": 1,
"discNumber": 1,
"trackCount": 20,
"trackNumber": 9,
"trackTimeMillis": 106533,
"country": "KOR",
"currency": "KRW",
"primaryGenreName": "힙합/랩",
"contentAdvisoryRating": "Explicit",
"isStreamable": true
}
""".data(using: .utf8)!


struct Medias: Decodable {
    let resultCount: Int
    let results: [Media]
}

struct Media: Decodable {
    let artistName: String
    let trackName: String
    let artworkUrl100: String
    let previewUrl: String
}

func test() {
    let result = try! JSONDecoder().decode(Media.self, from: testData)
    dump(result)
}
