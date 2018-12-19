//
//  NoteValueMeasurable.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/11/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

public protocol NoteValueMeasurable: DurationMeasurable {
  var noteValue: NoteValue { get }
}
