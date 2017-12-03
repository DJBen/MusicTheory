//
//  Interval.swift
//  MusicTheory
//
//  Created by Cem Olcay on 29/12/2016.
//  Copyright © 2016 cemolcay. All rights reserved.
//
//  https://github.com/cemolcay/MusicTheory
//

import Foundation

// MARK: - Interval

/// Adds two intervals and returns combined value of two.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Combined interval value of two.
public func +(lhs: Interval, rhs: Interval) -> Interval {
  return Interval(halfstep: lhs.halfstep + rhs.halfstep)
}

/// Subsracts two intervals and returns the interval value between two.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Interval between two intervals.
public func -(lhs: Interval, rhs: Interval) -> Interval {
  return Interval(halfstep: lhs.halfstep - rhs.halfstep)
}

/// Compares two `Interval` types.
///
/// - Parameters:
///   - lhs: Left hand side of the equation.
///   - rhs: Right hand side of the equation.
/// - Returns: Returns bool value of equeation.
public func ==(lhs: Interval, rhs: Interval) -> Bool {
  return lhs.halfstep == rhs.halfstep
}

/// Extends `Interval` by any given octave.
/// For example between C1 and D1, there are 2 halfsteps but between C1 and D2 there are 14 halfsteps.
//// ```.M2 * 2``` will give you D2 from a C1.
///
/// - Parameters:
///   - interval: Interval you want to extend by an octave.
///   - octave: Octave you want to extend your interval by.
/// - Returns: Returns new interval by calculating halfsteps between target interval and octave.
public func *(interval: Interval, octave: Int) -> Interval {
  return Interval(halfstep: interval.halfstep + (12 * (octave - 1)))
}

/// Defines the interval between `Note`s in halfstep tones and degrees.
public enum Interval: Equatable, ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = Int

  /// Zero halfstep and zero degree, the note itself.
  case unison
  /// One halfstep and one degree between notes.
  case m2
  /// Two halfsteps and one degree between notes.
  case M2
  /// Three halfsteps and two degree between notes.
  case m3
  /// Four halfsteps and two degree between notes.
  case M3
  /// Five halfsteps and three degree between notes.
  case P4
  /// Six halfsteps and four degree between notes.
  case d5
  /// Seven halfsteps and four degree between notes.
  case P5
  /// Eight halfsteps and five degree between notes.
  case m6
  /// Nine halfsteps and five degree between notes.
  case M6
  /// Ten halfsteps and six degree between notes.
  case m7
  /// Eleven halfsteps and six degree between notes.
  case M7
  /// Twelve halfsteps and seven degree between notes.
  case P8
  /// Custom halfsteps and degrees by given input between notes.
  case custom(halfstep: Int)

  /// Initilizes interval with its degree and halfstep.
  ///
  /// - Parameters:
  ///   - degree: Degree of interval.
  ///   - halfstep: Halfstep of interval.
  public init(halfstep: Int) {
    switch halfstep {
    case 0: self = .unison
    case 1: self = .m2
    case 2: self = .M2
    case 3: self = .m3
    case 4: self = .M3
    case 5: self = .P4
    case 6: self = .d5
    case 7: self = .P5
    case 8: self = .m6
    case 9: self = .M6
    case 10: self = .m7
    case 11: self = .M7
    case 12: self = .P8
    default: self = .custom(halfstep: halfstep)
    }
  }

  /// ExpressibleByIntegerLiteral init function.
  /// You can convert Int value of halfsteps to Interval.
  ///
  /// -           :
  ///   - value: Halfstep value of Interval.
  public init(integerLiteral value: IntegerLiteralType) {
    self.init(halfstep: value)
  }

  /// Returns the degree of the `Interval`.
  public var degree: Int {
    switch self {
    case .m2, .M2: return 1
    case .M3, .m3: return 2
    case .P4: return 3
    case .d5, .P5: return 4
    case .m6, .M6: return 5
    case .m7, .M7: return 6
    case .P8: return 7
    default: return 0
    }
  }

  /// Returns halfstep representation of `Interval.`
  public var halfstep: Int {
    switch self {
    case .unison: return 0
    case .m2: return 1
    case .M2: return 2
    case .m3: return 3
    case .M3: return 4
    case .P4: return 5
    case .d5: return 6
    case .P5: return 7
    case .m6: return 8
    case .M6: return 9
    case .m7: return 10
    case .M7: return 11
    case .P8: return 12
    case .custom(let h): return h
    }
  }
}

extension Interval: Codable {

  /// Keys that conforms CodingKeys protocol to map properties.
  private enum CodingKeys: String, CodingKey {
    /// Halfstep property of `Interval`.
    case halfstep
  }

  /// Decodes struct with a decoder.
  ///
  /// - Parameter decoder: Decodes encoded struct.
  /// - Throws: Tries to initlize struct with a decoder.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let halfstep = try values.decode(Int.self, forKey: .halfstep)
    self = Interval(halfstep: halfstep)
  }

  /// Encodes struct with an ecoder.
  ///
  /// - Parameter encoder: Encodes struct.
  /// - Throws: Tries to encode struct.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(halfstep, forKey: .halfstep)
  }
}

extension Interval: CustomStringConvertible {

  public var description: String {
    switch self {
    case .unison: return "unison"
    case .m2: return "minor second"
    case .M2: return "major second"
    case .m3: return "minor third"
    case .M3: return "major third"
    case .P4: return "perfect forth"
    case .d5: return "diminished fifth"
    case .P5: return "perfect fifth"
    case .m6: return "minor sixth"
    case .M6: return "major sixth"
    case .m7: return "minor seventh"
    case .M7: return "major seventh"
    case .P8: return "octave"
    case .custom(let halfstep): return "\(halfstep)th"
    }
  }

  /// Roman numeric value of interval by its halfstep value.
  public var roman: String {
    switch self {
    case .unison: return "i"
    case .m2: return "ii"
    case .M2: return "II"
    case .m3: return "iii"
    case .M3: return "III"
    case .P4: return "IV"
    case .d5: return "v"
    case .P5: return "V"
    case .m6: return "vi"
    case .M6: return "VI"
    case .m7: return "vii"
    case .M7: return "VII"
    case .P8: return "VII"
    case .custom(let halfstep): return "\(halfstep)"
    }
  }
}
