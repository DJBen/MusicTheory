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

// MARK: - Note Value

/// Defines the types of note values.
public enum NoteValueType: Double, Codable {

  /// Two whole notes.
  case doubleWhole = 0.5
  /// Whole note.
  case whole = 1
  /// Half note.
  case half = 2
  /// Quarter note.
  case quarter = 4
  /// Eighth note.
  case eighth = 8
  /// Sixteenth note.
  case sixteenth = 16
  /// Thirtysecond note.
  case thirtysecond = 32
  /// Sixtyfourth note.
  case sixtyfourth = 64
}

/// Defines the lenght of a `NoteValue`
public enum NoteModifier: Double, Codable {
  /// No additional lenght.
  case `default` = 1
  /// Adds half of its own value.
  case dotted = 1.5
  /// Three notes of the same value.
  case triplet = 0.67
}

/// Defines the duration of a note beatwise.
public struct NoteValue: Codable {
  /// Type that represents the duration of note.
  public var type: NoteValueType
  /// Modifier for `NoteType` that modifies the duration.
  public var modifier: NoteModifier

  /// Initilize the NoteValue with its type and optional modifier.
  ///
  /// - Parameters:
  ///   - type: Type of note value that represents note duration.
  ///   - modifier: Modifier of note value. Defaults `default`.
  public init(type: NoteValueType, modifier: NoteModifier = .default) {
    self.type = type
    self.modifier = modifier
  }
}
