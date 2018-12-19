//
//  Note.swift
//  MusicTheorySwift
//
//  Created by Ben Lu on 10/15/18.
//

public protocol ProtoPassageComponent: NoteValueMeasurable {}

public class Rest: NoteValueMeasurable, ProtoPassageComponent {
  public let noteValue: NoteValue

  public init(noteValue: NoteValue) {
    self.noteValue = noteValue
  }

  public var duration: Double {
    return noteValue.duration
  }
}

public class UnknownPitchNote: NoteValueMeasurable, ProtoPassageComponent {
  public let noteValue: NoteValue

  public init(noteValue: NoteValue) {
    self.noteValue = noteValue
  }

  public var duration: Double {
    return noteValue.duration
  }

  func assign(pitch: Pitch) -> Note {
    return Note(pitch: pitch, noteValue: noteValue)
  }
}

public struct Note: NoteValueMeasurable {
  public let pitch: Pitch
  public let noteValue: NoteValue

  public init(pitch: Pitch, noteValue: NoteValue) {
    self.pitch = pitch
    self.noteValue = noteValue
  }

  public var duration: Double {
    return noteValue.duration
  }
}

public struct PitchGroup {
  public let pitches: [Pitch]

  public init(arpeggio chord: Chord, atOctave octave: Int, chordPartOrder: [ChordPart]) {
    assert(chord.type.hasChordParts(chordPartOrder), "This chord does not contain some of the specified chord parts")

    let root = Pitch(key: chord.key, octave: octave)
    pitches = chordPartOrder.map { root + $0.interval }
  }
}

public struct RhythmGroup: DurationMeasurable {
  public let protoPassageComponents: [ProtoPassageComponent]

  public var duration: Double {
    return protoPassageComponents.reduce(0.0, { $0 + $1.duration })
  }

  public init(protoPassageComponents: [ProtoPassageComponent]) {
    self.protoPassageComponents = protoPassageComponents
  }

  public func passage(byAssigningPitches pitches: [Pitch]) -> Passage {
    assert(protoPassageComponents.filter { $0 is UnknownPitchNote }.count == pitches.count, "Number of the non-rest note values and pitches must agree")
    var components: [Passage.Component] = []
    var pitchIndex: Int = 0

    for protoComponent in protoPassageComponents {
      if let protoNote = protoComponent as? UnknownPitchNote {
        components.append(Passage.Component.note(protoNote.assign(pitch: pitches[pitchIndex])))
        pitchIndex += 1
      } else if let rest = protoComponent as? Rest {
        components.append(Passage.Component.rest(rest))
      } else {
        fatalError()
      }
    }

    return Passage(components: components)
  }
}
