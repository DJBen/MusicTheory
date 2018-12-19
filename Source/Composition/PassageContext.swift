//
//  PassageContext.swift
//  MusicTheory
//
//  Created by Sihao Lu on 12/1/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

public class PassageContext: TimeSignatureProvider {
  public let key: Key
  public let timeSignature: TimeSignature

  public init(key: Key, timeSignature: TimeSignature) {
    self.key = key
    self.timeSignature = timeSignature
  }
}

public class AttachedPassageContext: PassageContext, TempoProvider {
  public let bpm: Double

  public var tempo: Tempo {
    return Tempo(timeSignature: timeSignature, bpm: bpm)
  }

  public init(key: Key, timeSignature: TimeSignature, bpmProvider: BpmProvider) {
    bpm = bpmProvider.bpm
    super.init(key: key, timeSignature: timeSignature)
  }
}
