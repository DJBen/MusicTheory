//
//  Tempo.swift
//  MusicTheory
//
//  Created by Cem Olcay on 29/12/2016.
//  Copyright © 2016 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Time Signature

/// Defines how many beats in a measure with which note value.
public struct TimeSignature: Codable {
  /// Beats per measure.
  public var beats: Int

  /// Note value per beat.
  public var noteValue: NoteValueType

  /// Initilizes the time signature with beats per measure and the value of the notes in beat.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - noteValue: Note value of the beats.
  public init(beats: Int = 4, noteValue: NoteValueType = .quarter) {
    self.beats = beats
    self.noteValue = noteValue
  }

  /// Initilizes the time signature with beats per measure and the value of the notes in beat. Returns nil if a division is not match a `NoteValue`.
  ///
  /// - Parameters:
  ///   - beats: Number of beats in a measure
  ///   - division: Number of the beats.
  public init?(beats: Int = 4, division: Int = 4) {
    guard let noteValue = NoteValueType(rawValue: Double(division)) else {
      return nil
    }

    self.beats = beats
    self.noteValue = noteValue
  }
}

// MARK: - Tempo

/// Defines the tempo of the music with beats per second and time signature.
public struct Tempo: Codable {
  /// Time signature of music.
  public var timeSignature: TimeSignature

  /// Beats per minutes.
  public var bpm: Double

  /// Initilizes tempo with time signature and BPM.
  ///
  /// - Parameters:
  ///   - timeSignature: Time Signature.
  ///   - bpm: Beats per minute.
  public init(timeSignature: TimeSignature = TimeSignature(), bpm: Double = 120.0) {
    self.timeSignature = timeSignature
    self.bpm = bpm
  }

  /// Caluclates the duration of a note value in seconds.
  public func duration(of noteValue: NoteValue) -> TimeInterval {
    let secondsPerBeat = 60.0 / bpm
    let secondsPerNote = secondsPerBeat * (timeSignature.noteValue.rawValue / noteValue.type.rawValue) * noteValue.modifier.rawValue
    return secondsPerNote
  }

  /// Calculates the LFO speed of a note vaule in hertz.
  public func hertz(of noteValue: NoteValue) -> Double {
    return 1 / duration(of: noteValue)
  }
}
