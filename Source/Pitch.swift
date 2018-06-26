//
//  Pitch.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

/// Returns the pitch above target interval from target pitch.
///
/// - Parameters:
///   - lhs: Target `Pitch`.
///   - rhs: Target `Interval`.
/// - Returns: Returns new pitch above target interval from target pitch.
public func +(lhs: Pitch, rhs: Interval) -> Pitch {
  let degree = rhs.degree - 1
  let targetKeyType = lhs.key.type.key(at: degree)
  let targetPitch = lhs + rhs.semitones
  return targetPitch.convert(to: targetKeyType, isHigher: true)
}

/// Returns the pitch below target interval from target pitch.
///
/// - Parameters:
///   - lhs: Target `Pitch`.
///   - rhs: Target `Interval`.
/// - Returns: Returns new pitch below target interval from target pitch.
public func -(lhs: Pitch, rhs: Interval) -> Pitch {
  let degree = -(rhs.degree - 1)
  let targetKeyType = lhs.key.type.key(at: degree)
  let targetPitch = lhs - rhs.semitones
  return targetPitch.convert(to: targetKeyType, isHigher: false)
}

/// Calculates the interval between two pitches.
/// Doesn't matter left hand side and right hand side note places.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: `Intreval` between two pitches. You can get the halfsteps from interval as well.
public func -(lhs: Pitch, rhs: Pitch) -> Interval {
  let top = max(lhs, rhs)
  let bottom = min(lhs, rhs)
  let diff = top.rawValue - bottom.rawValue

  let bottomKeyIndex = Key.KeyType.all.index(of: bottom.key.type) ?? 0
  let topKeyIndex = Key.KeyType.all.index(of: top.key.type) ?? 0
  let degree = (topKeyIndex - bottomKeyIndex) + 1
  let isMajor = (degree == 2 || degree == 3 || degree == 6 || degree == 7)

  let majorScale = Scale(type: .major, key: bottom.key)
  if majorScale.pitches(octaves: [bottom.octave, top.octave]).contains(top) { // Major or Perfect
    return Interval(
      quality: isMajor ? .major : .perfect,
      degree: degree,
      semitones: diff)
  } else { // Augmented, Diminished or Minor
    if isMajor {
      let majorPitch = bottom + Interval(quality: .major, degree: degree, semitones: diff)
      let offset = top.rawValue - majorPitch.rawValue
      return Interval(
        quality: offset > 0 ? .augmented : .minor,
        degree: degree,
        semitones: diff)
    } else {
      let perfectPitch = bottom + Interval(quality: .perfect, degree: degree, semitones: diff)
      let offset = top.rawValue - perfectPitch.rawValue
      return Interval(
        quality: offset > 0 ? .augmented : .diminished,
        degree: degree,
        semitones: diff)
    }
  }
}

/// Calculates the `Pitch` above halfsteps.
///
/// - Parameters:
///   - note: The pitch that is being added halfsteps.
///   - halfstep: Halfsteps above.
/// - Returns: Returns `Pitch` above halfsteps.
public func +(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue + halfstep)
}

/// Calculates the `Pitch` below halfsteps.
///
/// - Parameters:
///   - note: The pitch that is being calculated.
///   - halfstep: Halfsteps below.
/// - Returns: Returns `Pitch` below halfsteps.
public func -(pitch: Pitch, halfstep: Int) -> Pitch {
  return Pitch(midiNote: pitch.rawValue - halfstep)
}

/// Compares the equality of two pitches by their MIDI note value.
/// Alternative notes passes this equality. Use `===` function if you want to check exact equality in terms of exact keys.
///
/// - Parameters:
///   - left: Left handside `Pitch` to be compared.
///   - right: Right handside `Pitch` to be compared.
/// - Returns: Returns the bool value of comparisation of two pitches.
public func ==(left: Pitch, right: Pitch) -> Bool {
  return left.rawValue == right.rawValue
}

/// Compares the exact equality of two pitches by their keys and octaves.
/// Alternative notes not passes this equality. Use `==` function if you want to check equality in terms of MIDI note value.
///
/// - Parameters:
///   - left: Left handside `Pitch` to be compared.
///   - right: Right handside `Pitch` to be compared.
/// - Returns: Returns the bool value of comparisation of two pitches.
public func ===(left: Pitch, right: Pitch) -> Bool {
  return left.key == right.key && left.octave == right.octave
}

/// Compares two `Pitch`es in terms of their semitones.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns true if left hand side `Pitch` lower than right hand side `Pitch`.
public func < (lhs: Pitch, rhs: Pitch) -> Bool {
  return lhs.rawValue < rhs.rawValue
}

/// Pitch object with a `Key` and an octave.
/// Could be initilized with MIDI note number and preferred accidental type.
public struct Pitch: RawRepresentable, Codable, Equatable, Comparable, ExpressibleByIntegerLiteral, CustomStringConvertible {

  /// Key of the pitch like C, D, A, B with accidentals.
  public var key: Key

  /// Octave of the pitch.
  /// In theory this must be zero or a positive integer.
  /// But `Note` does not limit octave and calculates every possible octave including the negative ones.
  public var octave: Int

  /// Initilizes the `Pitch` with MIDI note number.
  ///
  /// - Parameter midiNote: Midi note in range of [0 - 127].
  /// - Parameter isPreferredAccidentalSharps: Make it true if preferred accidentals is sharps. Defaults true.
  public init(midiNote: Int, isPreferredAccidentalSharps: Bool = true) {
    octave = (midiNote / 12) - 1
    let keyIndex = midiNote % 12
    key = (isPreferredAccidentalSharps ? Key.keysWithSharps : Key.keysWithFlats)[keyIndex]
  }

  /// Initilizes the `Pitch` with `Key` and octave
  ///
  /// - Parameters:
  ///   - key: Key of the pitch.
  ///   - octave: Octave of the pitch.
  public init(key: Key, octave: Int) {
    self.key = key
    self.octave = octave
  }

  /// Converts and returns enharmonic equivalent pitch in target `KeyType`.
  ///
  /// - Parameters:
  ///   - keyType: Target `KeyType` you want to convert.
  ///   - interval: Calculates for the interval above or below dependent on `isHigher` parameter. Leave nil if you don't want to calculate interval. Defaults nil.
  ///   - isHigher: Is target key type is a higher pitch or not.
  /// - Returns: Returns the converted `Pitch` in target `KeyType`.
  public func convert(to keyType: Key.KeyType, for interval: Interval? = nil, isHigher: Bool) -> Pitch {
    // Set target octave
    var targetOctave = octave
    if isHigher {
      if keyType.rawValue < key.type.rawValue {
        targetOctave += 1
      }
    } else {
      if keyType.rawValue > key.type.rawValue {
        targetOctave -= 1
      }
    }

    // Convert pitch
    let pitch = interval == nil ? self : self + interval!
    var convertedPitch = Pitch(key: Key(type: keyType), octave: targetOctave)
    let diff = pitch.rawValue - convertedPitch.rawValue
    convertedPitch.key.accidental = Accidental(integerLiteral: diff)
    return convertedPitch
  }

  /// Calculates and returns the frequency of note on octave based on its location of piano keys.
  /// Bases A4 note of 440Hz frequency standard.
  public var frequency: Float {
    let fn = powf(2.0, Float(rawValue - 69) / 12.0)
    return fn * 440.0
  }

  // MARK: RawRepresentable

  public typealias RawValue = Int

  /// Returns midi note number.
  /// In theory, this must be in range [0 - 127].
  /// But it does not limits the midi note value.
  public var rawValue: Int {
    let semitones = key.type.rawValue + key.accidental.rawValue
    return semitones + ((octave + 1) * 12)
  }

  /// Initilizes the pitch with an integer value that represents the MIDI note number of the pitch.
  ///
  /// - Parameter rawValue: MIDI note number of the pitch.
  public init?(rawValue: Pitch.RawValue) {
    self = Pitch(midiNote: rawValue)
  }

  // MARK: ExpressibleByIntegerLiteral

  public typealias IntegerLiteralType = Int

  /// Initilizes the pitch with an integer value that represents the MIDI note number of the pitch.
  ///
  /// - Parameter value: MIDI note number of the pitch.
  public init(integerLiteral value: Pitch.IntegerLiteralType) {
    self = Pitch(midiNote: value)
  }

  // MARK: CustomStringConvertible

  /// Converts `Pitch` to string with its key and octave.
  public var description: String {
    return "\(key)\(octave)"
  }
}
