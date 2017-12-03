//
//  MusicTheory.swift
//  MusicTheory
//
//  Created by Cem Olcay on 29/12/2016.
//  Copyright © 2016 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - NoteType

/// Calculates the `NoteType` above `Interval`.
///
/// - Parameters:
///   - noteType: The note type being added interval.
///   - interval: Interval above.
/// - Returns: Returns `NoteType` above interval.
public func +(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + interval.halfstep)!
}

/// Calculates the `NoteType` above halfsteps.
///
/// - Parameters:
///   - noteType: The note type being added halfsteps.
///   - halfstep: Halfsteps above
/// - Returns: Returns `NoteType` above halfsteps
public func +(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue + halfstep)!
}

/// Calculates the `NoteType` below `Interval`.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - interval: Interval below.
/// - Returns: Returns `NoteType` below interval.
public func -(noteType: NoteType, interval: Interval) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - interval.halfstep)!
}

/// Calculates the `NoteType` below halfsteps.
///
/// - Parameters:
///   - noteType: The note type being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `NoteType` below halfsteps.
public func -(noteType: NoteType, halfstep: Int) -> NoteType {
  return NoteType(midiNote: noteType.rawValue - halfstep)!
}

public func ==(lhs: CNote, rhs: CNote) -> Bool {
  return lhs.halfsteps == rhs.halfsteps
}

public func ==(note: CNote, halfsteps: Int) -> Bool {
  return note.halfsteps == halfsteps
}

public func -(note: CNote, halfsteps: Int) -> Int {
  return note.halfsteps - halfsteps
}

public func +(note: CNote, halfsteps: Int) -> Int {
  return note.halfsteps + halfsteps
}

/// Defines 12 base notes in music.
/// C, D, E, F, G, A, B with their flats.
/// Raw values are included for easier calculation based on midi notes.
public enum NoteType: Int, Equatable, Codable {
  /// C note.
  case c = 0
  /// D♭ or C♯ note.
  case dFlat
  /// D note.
  case d
  /// E♭ or D♯ note.
  case eFlat
  /// E note.
  case e
  /// F note.
  case f
  /// G♭ or F♯ note.
  case gFlat
  /// G Note.
  case g
  /// A♭ or G♯ note.
  case aFlat
  /// A note.
  case a
  /// B♭ or A♯ note.
  case bFlat
  /// B note.
  case b

  /// All the notes in static array.
  public static let all: [NoteType] = [
    .c, .dFlat, .d, .eFlat, .e, .f,
    .gFlat, .g, .aFlat, .a, .bFlat, .b
  ]

  /// Initilizes the note type with midiNote.
  ///
  /// - parameters:
  ///  - midiNote: The midi note value wanted to be converted to `NoteType`.
  public init?(midiNote: Int) {
    let octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    let raw = octave > 0 ? midiNote - (octave * 12) : midiNote - ((octave + 1) * 12) + 12
    guard let note = NoteType(rawValue: raw) else { return nil }
    self = note
  }
}

extension NoteType: CustomStringConvertible {

  /// Converts `NoteType` to string with its name.
  public var description: String {
    switch self {
    case .c: return "C"
    case .dFlat: return "D♭"
    case .d: return "D"
    case .eFlat: return "E♭"
    case .e: return "E"
    case .f: return "F"
    case .gFlat: return "G♭"
    case .g: return "G"
    case .aFlat: return "A♭"
    case .a: return "A"
    case .bFlat: return "B♭"
    case .b: return "B"
    }
  }
}

// MARK: - Note

/// Calculates the `Note` above `Interval`.
///
/// - Parameters:
///   - note: The note being added interval.
///   - interval: Interval above.
/// - Returns: Returns `Note` above interval.
public func +(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote + interval.halfstep)
}

/// Calculates the `Note` above halfsteps.
///
/// - Parameters:
///   - note: The note being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Note` above halfsteps.
public func +(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote + halfstep)
}

/// Calculates the `Note` below `Interval`.
///
/// - Parameters:
///   - note: The note being calculated.
///   - interval: Interval below.
/// - Returns: Returns `Note` below interval.
public func -(note: Note, interval: Interval) -> Note {
  return Note(midiNote: note.midiNote - interval.halfstep)
}

/// Calculates the `Note` below halfsteps.
///
/// - Parameters:
///   - note: The note being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Note` below halfsteps.
public func -(note: Note, halfstep: Int) -> Note {
  return Note(midiNote: note.midiNote - halfstep)
}

/// Calculates the interval between two notes.
/// Doesn't matter left hand side and right hand side note places.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: `Intreval` between two notes. You can get the halfsteps from interval as well.
public func -(lhs: Note, rhs: Note) -> Interval {
  return Interval(halfstep: abs(rhs.midiNote - lhs.midiNote))
}

/// Compares the equality of two notes by their types and octaves.
///
/// - Parameters:
///   - left: Left handside `Note` to be compared.
///   - right: Right handside `Note` to be compared.
/// - Returns: Returns the bool value of comparisation of two notes.
public func ==(left: Note, right: Note) -> Bool {
  return left.type == right.type && left.octave == right.octave
}

/// Note object with `NoteType` and octave.
/// Could be initilized with midiNote.
public struct Note: Equatable, Codable {

  /// Type of the note like C, D, A, B.
  public var type: NoteType

  /// Octave of the note.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public var octave: Int

  /// Initilizes the `Note` from midi note.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  public init(midiNote: Int) {
    octave = (midiNote / 12) - (midiNote < 0 ? 1 : 0)
    type = NoteType(midiNote: midiNote)!
  }

  /// Initilizes the `Note` with `NoteType` and octave
  ///
  /// - Parameters:
  ///   - type: The type of the note in `NoteType` enum.
  ///   - octave: Octave of the note.
  public init(type: NoteType, octave: Int) {
    self.type = type
    self.octave = octave
  }

  /// Returns midi note value.
  /// In theory, this must be in range [0 - 127].
  /// But it does not limits the midi note value.
  public var midiNote: Int {
    return type.rawValue + (octave * 12)
  }
}

public extension Note {

  /// Returns the piano key number by octave based on a standard [1 - 88] key piano.
  public var pianoKey: Int {
    return midiNote + 4
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys.
  /// Bases A4 note of 440Hz frequency standard.
  public var frequency: Float {
    let fn = powf(2.0, Float(pianoKey - 49) / 12.0)
    return fn * 440.0
  }
}

extension Note: CustomStringConvertible {

  /// Converts `Note` to string with its type and octave.
  public var description: String {
    return "\(type)\(octave)"
  }
}

// MARK: - New Implementation

public struct CNote: Equatable, CustomStringConvertible {
  public var type: Base
  public var accident: Accident
  public var octave: Int

  public static let zero = CNote(type: .c, accident: .natural, octave: 0)

  public enum Base: Int, CustomStringConvertible {
    case c = 0
    case d = 2
    case e = 4
    case f = 5
    case g = 7
    case a = 9
    case b = 11

    public var halfsteps: Int {
      return rawValue
    }

    public var next: Base {
      switch self {
      case .c: return .d
      case .d: return .e
      case .e: return .f
      case .f: return .g
      case .g: return .a
      case .a: return .b
      case .b: return .c
      }
    }

    public var previous: Base {
      switch self {
      case .c: return .b
      case .d: return .c
      case .e: return .d
      case .f: return .e
      case .g: return .f
      case .a: return .g
      case .b: return .a
      }
    }

    public var description: String {
      switch self {
      case .c: return "C"
      case .d: return "D"
      case .e: return "E"
      case .f: return "F"
      case .g: return "G"
      case .a: return "A"
      case .b: return "B"
      }
    }
  }

  public enum Accident: CustomStringConvertible {
    case natural
    case flats(amount: Int)
    case sharps(amount: Int)

    public static let flat: Accident = .flats(amount: 1)
    public static let sharp: Accident = .sharps(amount: 1)
    public static let doubleFlat: Accident = .flats(amount: 2)
    public static let doubleSharp: Accident = .sharps(amount: 2)

    public var halfsteps: Int {
      switch self {
      case .natural: return 0
      case .flats(let amount): return -amount
      case .sharps(let amount): return amount
      }
    }

    public var notation: String {
      if case .natural = self {
        return "♮"
      }
      return description
    }

    public var description: String {
      switch self {
      case .natural:
        return ""
      case .flats(let amount):
        switch amount {
        case 0: return Accident.natural.description
        case 1: return "♭"
        case 2: return "𝄫"
        default: return amount > 0 ? (0..<amount).map({ _ in Accident.flats(amount: 1).description }).joined() : ""
        }
      case .sharps(let amount):
        switch amount {
        case 0: return Accident.natural.description
        case 1: return "♯"
        case 2: return "𝄪"
        default: return amount > 0 ? (0..<amount).map({ _ in Accident.sharps(amount: 1).description }).joined() : ""
        }
      }
    }
  }

  public init(type: Base, accident: Accident = .natural, octave: Int) {
    self.type = type
    self.accident = accident
    self.octave = octave
  }

  public init(halfsteps: Int, preferred notation: Accident = .flat) {
    var octave = (halfsteps / 12) - (halfsteps < 0 ? 1 : 0)
    let raw = octave > 0 ? halfsteps - (octave * 12) : halfsteps - ((octave + 1) * 12) + 12

    var type: Base = .c
    var accident: Accident = .natural
    switch raw {
    case 0:
      type = .c
    case 1, 2:
      type = .d
      accident = raw == 1 ? .flat : .natural
    case 3, 4:
      type = .e
      accident = raw == 3 ? .flat : .natural
    case 5:
      type = .f
    case 6, 7:
      type = .g
      accident = raw == 6 ? .flat : .natural
    case 8, 9:
      type = .a
      accident = raw == 8 ? .flat : .natural
    case 10, 11:
      type = .b
      accident = raw == 10 ? .flat : .natural
    default: type = .c
    }

    switch notation {
    case .natural:
      self = CNote(halfsteps: halfsteps)
    case .flats(let amount):
      self = CNote(type: type, accident: accident, octave: octave)
    case .sharps(let amount):
      self = CNote(type: type, accident: accident, octave: octave)
    }
  }

  public init(midiNote: Int) {
    self.init(halfsteps: midiNote - 12)
  }

  public var halfsteps: Int {
    return (octave * 12) + type.halfsteps + accident.halfsteps
  }

  public var midiNote: Int {
    return halfsteps - 12
  }

  public func alternate(notation accident: Accident = .flat) -> CNote? {
    return self
  }

  public var description: String {
    return "\(type)\(accident)\(octave)"
  }
}
