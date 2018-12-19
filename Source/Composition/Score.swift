//
//  Score.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/9/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

public struct Score {
  public struct Metadata {
    public let composer: String
    public let arranger: String
    public let lyricist: String
  }

  public let context: ScoreContext

  public let parts: [Part]
  public let metadata: Metadata?
}

public struct ScoreContext: BpmProvider {
  public let bpm: Double
}

public extension Score {
  public class Builder {
    public typealias BuilderBlock = (Builder) -> Void

    public var parts: [Part]?
    public var context: ScoreContext?
    public var metadata: Metadata?

    public init(builderBlock: BuilderBlock) {
      builderBlock(self)
    }
  }

  public init?(builder: Builder) {
    guard let context = builder.context, let parts = builder.parts else {
      return nil
    }
    self.context = context
    self.parts = parts
    metadata = builder.metadata
  }
}
