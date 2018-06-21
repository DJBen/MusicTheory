//
//  Enharmonics.swift
//  MusicTheory
//
//  Created by Cem Olcay on 21.06.2018.
//  Copyright © 2018 cemolcay. All rights reserved.
//

import Foundation

public enum Accident: CustomStringConvertible {
  case natural
  case flats(amount: Int)
  case sharps(amount: Int)

  public static let flat: Accident = .flats(amount: 1)
  public static let sharp: Accident = .sharps(amount: 1)
  public static let doubleFlat: Accident = .flats(amount: 2)
  public static let doubleSharp: Accident = .sharps(amount: 2)

  public var halfsteps: Int {
    switch self {
    case .natural: return 0
    case .flats(let amount): return -amount
    case .sharps(let amount): return amount
    }
  }

  public var notation: String {
    if case .natural = self {
      return "♮"
    }
    return description
  }

  public var description: String {
    switch self {
    case .natural:
      return ""
    case .flats(let amount):
      switch amount {
      case 0: return Accident.natural.description
      case 1: return "♭"
      case 2: return "𝄫"
      default: return amount > 0 ? (0..<amount).map({ _ in Accident.flats(amount: 1).description }).joined() : ""
      }
    case .sharps(let amount):
      switch amount {
      case 0: return Accident.natural.description
      case 1: return "♯"
      case 2: return "𝄪"
      default: return amount > 0 ? (0..<amount).map({ _ in Accident.sharps(amount: 1).description }).joined() : ""
      }
    }
  }
}
