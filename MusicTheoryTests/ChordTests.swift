//
//  ChordTests.swift
//  MusicTheoryTests
//
//  Created by Ben Lu on 12/5/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import MusicTheory
import XCTest

class ChordTests: XCTestCase {
  func testChords() {
    let cmajNotes: [Key] = [Key(type: .c), Key(type: .e), Key(type: .g)]
    let cmaj = Chord(type: ChordType(third: .major), key: Key(type: .c))
    XCTAssert(cmajNotes == cmaj.keys)

    let cminNotes: [Key] = [
      Key(type: .c),
      Key(type: .e, accidental: .flat),
      Key(type: .g),
    ]
    let cmin = Chord(type: ChordType(third: .minor), key: Key(type: .c))
    XCTAssert(cminNotes == cmin.keys)

    let c13Notes: [Pitch] = [
      Pitch(key: Key(type: .c), octave: 1),
      Pitch(key: Key(type: .e), octave: 1),
      Pitch(key: Key(type: .g), octave: 1),
      Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .d), octave: 2),
      Pitch(key: Key(type: .f), octave: 2),
      Pitch(key: Key(type: .a), octave: 2),
    ]
    let c13 = Chord(
      type: ChordType(
        third: .major,
        seventh: .dominant,
        extensions: [
          ChordExtensionType(type: .thirteenth),
        ]
      ),
      key: Key(type: .c)
    )
    XCTAssert(c13.pitches(octave: 1) === c13Notes)

    let cm13Notes: [Pitch] = [
      Pitch(key: Key(type: .c), octave: 1),
      Pitch(key: Key(type: .e, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .g), octave: 1),
      Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .d), octave: 2),
      Pitch(key: Key(type: .f), octave: 2),
      Pitch(key: Key(type: .a), octave: 2),
    ]
    let cm13 = Chord(
      type: ChordType(
        third: .minor,
        seventh: .dominant,
        extensions: [
          ChordExtensionType(type: .thirteenth),
        ]
      ),
      key: Key(type: .c)
    )
    XCTAssert(cm13.pitches(octave: 1) === cm13Notes)

    let minorIntervals: [Interval] = [.P1, .m3, .P5]
    guard let minorChord = ChordType(intervals: minorIntervals.map({ $0 })) else { return XCTFail() }
    XCTAssert(minorChord == ChordType(third: .minor))

    let majorIntervals: [Interval] = [.P1, .M3, .P5]
    guard let majorChord = ChordType(intervals: majorIntervals.map({ $0 })) else { return XCTFail() }
    XCTAssert(majorChord == ChordType(third: .major))

    let cmadd13Notes: [Pitch] = [
      Pitch(key: Key(type: .c), octave: 1),
      Pitch(key: Key(type: .e, accidental: .flat), octave: 1),
      Pitch(key: Key(type: .g), octave: 1),
      Pitch(key: Key(type: .a), octave: 2),
    ]
    let cmadd13 = Chord(
      type: ChordType(
        third: .minor,
        extensions: [ChordExtensionType(type: .thirteenth)]
      ),
      key: Key(type: .c)
    )
    XCTAssert(cmadd13.pitches(octave: 1) === cmadd13Notes)
  }

  func testChordEquality() {
    let gSus4No5Add6 = Chord(type: ChordType(third: nil, fifth: nil, sixth: ChordSixthType(), suspended: .sus4), key: Key(type: .g))
    let cMajOverG = Chord(type: ChordType(third: .major, fifth: .perfect), key: Key(type: .c), inversion: 2)
    let cMajOverE = Chord(type: ChordType(third: .major, fifth: .perfect), key: Key(type: .c), inversion: 1)
    XCTAssertEqual(gSus4No5Add6, cMajOverG)
    XCTAssertNotEqual(gSus4No5Add6, cMajOverE)
    XCTAssertNotEqual(Chord(type: ChordType(third: .major), key: Key(type: .c)), cMajOverE)
  }

  func testNotationAndDescriptions() {
    let g5 = Chord(type: ChordType(third: nil, fifth: .perfect, sixth: nil, seventh: nil, suspended: nil, extensions: nil), key: Key(type: "G"))

    XCTAssertEqual(g5.notation, "G5")
    XCTAssertEqual(g5.description, "G (no 3)")
  }

  func testInversions() {
    let c7 = Chord(
      type: ChordType(third: .major, seventh: .dominant),
      key: Key(type: .c)
    )
    let c7Inversions = [
      [
        Pitch(key: Key(type: .c), octave: 1),
        Pitch(key: Key(type: .e), octave: 1),
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
      ],
      [
        Pitch(key: Key(type: .e), octave: 1),
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
      ],
      [
        Pitch(key: Key(type: .g), octave: 1),
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
        Pitch(key: Key(type: .e), octave: 2),
      ],
      [
        Pitch(key: Key(type: .b, accidental: .flat), octave: 1),
        Pitch(key: Key(type: .c), octave: 2),
        Pitch(key: Key(type: .e), octave: 2),
        Pitch(key: Key(type: .g), octave: 2),
      ],
    ]
    for (index, chord) in c7.inversions.enumerated() {
      XCTAssert(chord.pitches(octave: 1) === c7Inversions[index])
    }
  }

  func testChordsFromStringLiterals_triads() {
    let majorChord: Chord = "D"
    XCTAssertEqual(majorChord, Chord(type: ChordType(third: .major), key: Key(type: .d)))
    let majorChordV2: Chord = "Fmaj"
    XCTAssertEqual(majorChordV2, Chord(type: ChordType(third: .major), key: Key(type: .f)))

    let minorChord: Chord = "Em"
    let minorChordV2: Chord = "Emin"
    XCTAssertEqual(minorChord, Chord(type: ChordType(third: .minor), key: Key(type: .e)))
    XCTAssertEqual(minorChordV2, Chord(type: ChordType(third: .minor), key: Key(type: .e)))

    let diminishedChord: Chord = "Adim"
    let diminishedChordV2: Chord = "Ao"
    let diminishedChordV3: Chord = "A°"
    XCTAssertEqual(diminishedChord, Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .a)))
    XCTAssertEqual(diminishedChordV2, Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .a)))
    XCTAssertEqual(diminishedChordV3, Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .a)))

    let augmentedChord: Chord = "B♭aug"
    let augmentedChordV2: Chord = "B♭+"
    XCTAssertEqual(augmentedChord, Chord(type: ChordType(third: .major, fifth: .augmented), key: Key(type: .b, accidental: .flat)))
    XCTAssertEqual(augmentedChordV2, Chord(type: ChordType(third: .major, fifth: .augmented), key: Key(type: .b, accidental: .flat)))
  }

  func testChordsFromStringLiterals_seventh() {
    let seventhChord: Chord = "D7"
    XCTAssertEqual(seventhChord, Chord(type: ChordType(third: .major, seventh: .dominant), key: Key(type: .d)))
    let majorSeventhChord: Chord = "Fmaj7"
    XCTAssertEqual(majorSeventhChord, Chord(type: ChordType(third: .major, seventh: .major), key: Key(type: .f)))

    let minor7thChord: Chord = "Em7"
    let minor7thChordV2: Chord = "Emin7"
    XCTAssertEqual(minor7thChord, Chord(type: ChordType(third: .minor, seventh: .dominant), key: Key(type: .e)))
    XCTAssertEqual(minor7thChordV2, Chord(type: ChordType(third: .minor, seventh: .dominant), key: Key(type: .e)))

    let diminishedChord: Chord = "Adim"
    let diminishedChordV2: Chord = "Ao"
    XCTAssertEqual(diminishedChord, Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .a)))
    XCTAssertEqual(diminishedChordV2, Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .a)))

    let augmentedChord: Chord = "B♭aug"
    let augmentedChordV2: Chord = "B♭+"
    XCTAssertEqual(augmentedChord, Chord(type: ChordType(third: .major, fifth: .augmented), key: Key(type: .b, accidental: .flat)))
    XCTAssertEqual(augmentedChordV2, Chord(type: ChordType(third: .major, fifth: .augmented), key: Key(type: .b, accidental: .flat)))

    let minorMajorChord: Chord = "Cmin(maj7)"
    XCTAssertEqual(minorMajorChord, Chord(type: ChordType(third: .minor, fifth: .perfect, seventh: .major), key: Key(type: .c)))

    let halfDimChord: Chord = "F#ø7"
    XCTAssertEqual(halfDimChord, Chord(type: ChordType(third: .minor, fifth: .diminished, seventh: .dominant), key: Key(type: .f, accidental: .sharp)))
  }

  func testChordsFromStringLiterals_extensions() {
    let seventhChord: Chord = "G♭6"
    XCTAssertEqual(seventhChord, Chord(type: ChordType(third: .major, sixth: ChordSixthType()), key: Key(type: .g, accidental: .flat)))

    let fSharpFlat5: Chord = "F♯m(♭5)"
    XCTAssertEqual(fSharpFlat5, Chord(type: ChordType(third: .minor, fifth: .diminished), key: Key(type: .f, accidental: .sharp)))

    let d9: Chord = "D9"
    XCTAssertEqual(d9, Chord(type: ChordType(third: .major, seventh: .dominant, extensions: [ChordExtensionType(type: .ninth)]), key: Key(type: .d)))

    let gSevenFlat5: Chord = "G7(b5)"
    XCTAssertEqual(gSevenFlat5, Chord(type: ChordType(third: .major, fifth: .diminished, seventh: .dominant), key: Key(type: .g)))

    let c9sus4: Chord = "C9(sus4)"
    XCTAssertEqual(c9sus4, Chord(type: ChordType(third: .major, seventh: .dominant, suspended: .sus4, extensions: [ChordExtensionType(type: .ninth)]), key: Key(type: .c)))

    let eb9sus4no5add6: Chord = "E♭9(sus4)(no5)(add6)"
    XCTAssertEqual(eb9sus4no5add6, Chord(type: ChordType(third: .major, fifth: nil, sixth: ChordSixthType(), seventh: .dominant, suspended: .sus4, extensions: [ChordExtensionType(type: .ninth)]), key: Key(type: .e, accidental: .flat)))
  }

}
