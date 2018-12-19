//
//  ChordProgression.swift
//  MusicTheory
//
//  Created by Cem Olcay on 2.10.2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import Foundation

public struct ChordProgression: CustomStringConvertible, Equatable {
  public let chords: [Chord]

  public init(chords: [Chord]) {
    self.chords = chords
  }

  // MARK: CustomStringConvertible

  public var description: String {
    return chords.map({ $0.notation }).joined(separator: " - ")
  }

  // MARK: Equatable

  public static func == (lhs: ChordProgression, rhs: ChordProgression) -> Bool {
    return lhs.chords == rhs.chords
  }
}

public extension ChordProgression {
  public class Builder {
    public typealias BuilderBlock = (Builder) -> Void

    public var chords: [Chord]?

    public init(builderBlock: BuilderBlock) {
      builderBlock(self)
    }
  }

  public init?(builder: Builder) {
    guard let chords = builder.chords else {
      return nil
    }
    self.chords = chords
  }
}
