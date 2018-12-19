//
//  TempoProvider.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/11/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

public protocol BpmProvider {
  var bpm: Double { get }
}

public protocol TimeSignatureProvider {
  var timeSignature: TimeSignature { get }
}

public protocol TempoProvider: BpmProvider, TimeSignatureProvider {
  var tempo: Tempo { get }
}
