//
//  BuilderTests.swift
//  MusicTheoryTests
//
//  Created by Sihao Lu on 12/1/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import MusicTheory
import XCTest

class BuilderTests: XCTestCase {
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testBuilder() {
    let firstChord = Chord(builder: Chord.Builder { chordBuilder in
      chordBuilder.type = ChordType(builder: ChordType.Builder { chordTypeBuilder in
        chordTypeBuilder.fifth = .perfect
      })
      chordBuilder.key = Key(builder: Key.Builder { keyBuilder in
        keyBuilder.type = .a
        keyBuilder.accidental = .natural
      })
    })
    let secondChord = Chord(builder: Chord.Builder { chordBuilder in
      chordBuilder.type = ChordType(builder: ChordType.Builder { chordTypeBuilder in
        chordTypeBuilder.fifth = .perfect
      })
      chordBuilder.key = Key(builder: Key.Builder { keyBuilder in
        keyBuilder.type = .a
        keyBuilder.accidental = .natural
      })
    })
  }
}
