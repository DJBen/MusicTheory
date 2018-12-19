//
//  DurationMeasurable.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/11/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

/// A protocol to provide duration counting. All conformists should expose countable duration in whole notes.
public protocol DurationMeasurable {
  /// Duration in whole notes
  var duration: Double { get }
}
