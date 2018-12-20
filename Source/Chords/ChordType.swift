//
//  ChordType.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/29/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

/// Defines full type of chord with all chord parts.
public struct ChordType: RegexStringLiteralExtractable {
  static let unitSymbolPattern = "[\\w\\d+°♭♯]"
  public static let pattern = "(\(unitSymbolPattern)*)" + (0 ..< 9).map { _ in "(?:\\((\(unitSymbolPattern)+)\\))?" }.joined()

  /// Thirds part. Second note of the chord.
  public var third: ChordThirdType?
  /// Fifths part. Third note of the chord.
  public var fifth: ChordFifthType?
  /// Defines a sixth chord. Defaults nil.
  public var sixth: ChordSixthType?
  /// Defines a seventh chord. Defaults nil.
  public var seventh: ChordSeventhType?
  /// Defines a suspended chord. Defaults nil.
  public var suspended: ChordSuspendedType?
  /// Defines extended chord. Defaults nil.
  public var extensions: [ChordExtensionType]? {
    didSet {
      if extensions?.count == 1 {
        extensions![0].isAdded = seventh == nil
        // Add other extensions if needed
        if let ext = extensions?.first, ext.type == .eleventh, !ext.isAdded {
          extensions?.append(ChordExtensionType(type: .ninth))
        } else if let ext = extensions?.first, ext.type == .thirteenth, !ext.isAdded {
          extensions?.append(ChordExtensionType(type: .ninth))
          extensions?.append(ChordExtensionType(type: .eleventh))
        }
      }
    }
  }

  /// Initilze the chord type with its parts.
  ///
  /// - Parameters:
  ///   - third: Thirds part. Defaults nil.
  ///   - fifth: Fifths part. Defaults perfect fifth.
  ///   - sixth: Sixth part. Defaults nil.
  ///   - seventh: Seventh part. Defaults nil.
  ///   - suspended: Suspended part. Defaults nil.
  ///   - extensions: Extended chords part. Defaults nil. Could be add more than one extended chord.
  public init(third: ChordThirdType?, fifth: ChordFifthType? = .perfect, sixth: ChordSixthType? = nil, seventh: ChordSeventhType? = nil, suspended: ChordSuspendedType? = nil, extensions: [ChordExtensionType]? = nil) {
    self.third = third
    self.fifth = fifth
    self.sixth = sixth
    self.seventh = seventh
    self.suspended = suspended
    self.extensions = extensions

    if extensions?.count == 1 {
      self.extensions![0].isAdded = seventh == nil
      // Add other extensions if needed
      if let ext = self.extensions?.first, ext.type == .eleventh, !ext.isAdded {
        self.extensions?.append(ChordExtensionType(type: .ninth))
      } else if let ext = self.extensions?.first, ext.type == .thirteenth, !ext.isAdded {
        self.extensions?.append(ChordExtensionType(type: .ninth))
        self.extensions?.append(ChordExtensionType(type: .eleventh))
      }
    }
  }

  /// Initilze the chord type with its intervals.
  ///
  /// - Parameters:
  ///   - intervals: Intervals of chord notes distances between root note for each.
  public init?(intervals: [Interval]) {
    var third: ChordThirdType?
    var fifth: ChordFifthType?
    var sixth: ChordSixthType?
    var seventh: ChordSeventhType?
    var suspended: ChordSuspendedType?
    var extensions = [ChordExtensionType]()

    for interval in intervals {
      if let thirdPart = ChordThirdType(interval: interval) {
        third = thirdPart
      } else if let fifthPart = ChordFifthType(interval: interval) {
        fifth = fifthPart
      } else if let sixthPart = ChordSixthType(interval: interval) {
        sixth = sixthPart
      } else if let seventhPart = ChordSeventhType(interval: interval) {
        seventh = seventhPart
      } else if let suspendedPart = ChordSuspendedType(interval: interval) {
        suspended = suspendedPart
      } else if let extensionPart = ChordExtensionType(interval: interval) {
        extensions.append(extensionPart)
      }
    }

    self = ChordType(
      third: third,
      fifth: fifth,
      sixth: sixth,
      seventh: seventh,
      suspended: suspended,
      extensions: extensions
    )
  }

  /// Intervals of parts between root.
  public var intervals: [Interval] {
    var parts: [ChordPart?] = [third, suspended, fifth, sixth, seventh]
    parts += extensions?.sorted(by: { $0.type.rawValue < $1.type.rawValue }).map({ $0 as ChordPart? }) ?? []
    return [.P1] + parts.compactMap({ $0?.interval })
  }

  /// Whether the chord type contains all of the specified chord parts.
  ///
  /// - Parameter chordParts: chord parts to check
  /// - Returns: true if the chord type contains all of the specified chord parts
  func hasChordParts(_ chordParts: [ChordPart]) -> Bool {
    return chordParts.allSatisfy { chordPart in
      self.intervals.contains(chordPart.interval)
    }
  }

  /// Description of the chord type.
  public var description: String {
    let seventhNotation = seventh?.description
    let sixthNotation = sixth?.description
    let suspendedNotation = suspended?.description
    let extensionsNotation = extensions?
      .sorted(by: { $0.type.rawValue < $1.type.rawValue })
      .map({ $0.description as String? }) ?? []

    let thirdDescription: String?
    let fifthDescription: String?

    if let fifth = fifth, let third = third {
      thirdDescription = third.description
      fifthDescription = fifth.description
    } else if let fifth = fifth {
      thirdDescription = "(no 3)"
      fifthDescription = fifth.description.isEmpty ? nil : fifth.description
    } else if let third = third {
      thirdDescription = third.description
      fifthDescription = "(no 5)"
    } else {
      thirdDescription = "(no 3)"
      fifthDescription = "(no 5)"
    }

    let desc = [thirdDescription, fifthDescription, sixthNotation, seventhNotation, suspendedNotation] + extensionsNotation
    return desc.compactMap({ $0 }).joined(separator: " ")
  }

  /// All possible chords could be generated.
  public static var all: [ChordType] {
    func combinations(_ elements: [ChordExtensionType], taking: Int = 1) -> [[ChordExtensionType]] {
      guard elements.count >= taking else { return [] }
      guard elements.count > 0 && taking > 0 else { return [[]] }

      if taking == 1 {
        return elements.map { [$0] }
      }

      var comb = [[ChordExtensionType]]()
      for (index, element) in elements.enumerated() {
        var reducedElements = elements
        reducedElements.removeFirst(index + 1)
        comb += combinations(reducedElements, taking: taking - 1).map { [element] + $0 }
      }
      return comb
    }

    var all = [ChordType]()
    let allThird = ChordThirdType.all
    let allFifth = ChordFifthType.all
    let allSixth: [ChordSixthType?] = [ChordSixthType(), nil]
    let allSeventh: [ChordSeventhType?] = ChordSeventhType.all + [nil]
    let allSus: [ChordSuspendedType?] = ChordSuspendedType.all + [nil]
    let allExt = combinations(ChordExtensionType.all) +
      combinations(ChordExtensionType.all, taking: 2) +
      combinations(ChordExtensionType.all, taking: 3)

    for third in allThird {
      for fifth in allFifth {
        for sixth in allSixth {
          for seventh in allSeventh {
            for sus in allSus {
              for ext in allExt {
                all.append(ChordType(
                  third: third,
                  fifth: fifth,
                  sixth: sixth,
                  seventh: seventh,
                  suspended: sus,
                  extensions: ext
                ))
              }
            }
          }
        }
      }
    }
    return all
  }

  public typealias StringLiteralType = String

  /// Initializes ChordType with a string literal notation.
  ///
  /// The notation can either be in short format or long format, as described in see also section.
  /// No superscript is accepted.
  ///
  /// - Rules:
  ///   - Both `M` and `maj` denotes a minor chord. Both `m` and `min` denotes a minor chord.
  ///   - Both `o` and `dim` denotes a diminished fifth chord.
  ///   - Both `+` and `aug` denotes an augmented fifth chord.
  ///   - Use `m(M7)` or `min(maj7)` to denote a minor-najor sevens chord.
  ///   - Use `Ø`, `ø`, or `ø7` to denote a half-diminished seventh chord.
  ///   - Use `(♭5)`, `(♯5)` to modify the quality of a chord component.
  ///   - b/♭ and #/♯ are interchangable.
  ///   - Use `add6`, `no5`, `sus4`, `add♯11` to denote addition, removal or subtitution of a chord component.
  ///   - All notations after the first notation requires parenthesis, for example, m7(add♯9).
  ///
  /// - Parameter value: String representation of the chord type
  ///
  /// - See Also: https://en.wikipedia.org/wiki/Chord_names_and_symbols_(popular_music)#Examples
  public init(regexMatches: [String]) {
    let baseNotation = String(regexMatches[1])
    guard let baseNotationRegex = try? NSRegularExpression(pattern: "((?:[A-Za-z]|[\\+°Øø])*)(\\d)?", options: []),
      let baseNotationMatch = baseNotationRegex.firstMatch(in: baseNotation, options: [], range: NSRange(0 ..< baseNotation.count)) else {
      fatalError("Invalid base chord type format.")
    }

    let nonNumeralBaseNotationRange = Range(baseNotationMatch.range(at: 1), in: baseNotation)
    let numeralBaseNotationRange = Range(baseNotationMatch.range(at: 2), in: baseNotation)

    let builder = ChordType.Builder { builder in
      let nonNumeralBaseNotation = nonNumeralBaseNotationRange != nil ? String(baseNotation[nonNumeralBaseNotationRange!]) : ""

      switch nonNumeralBaseNotation {
      case "", "M", "maj":
        builder.third = .major
        builder.fifth = .perfect
      case "m", "min":
        builder.third = .minor
        builder.fifth = .perfect
      case "°", "o", "dim":
        builder.third = .minor
        builder.fifth = .diminished
      case "+", "aug":
        builder.third = .major
        builder.fifth = .augmented
      case "Ø", "ø":
        builder.third = .minor
        builder.fifth = .diminished
      default:
        fatalError()
      }

      let numeralBaseNotation = numeralBaseNotationRange != nil ? String(baseNotation[numeralBaseNotationRange!]) : ""

      switch numeralBaseNotation {
      case "":
        break
      case "5":
        builder.third = nil
      case "6":
        builder.sixth = ChordSixthType()
      case "7":
        if nonNumeralBaseNotation == "M" || nonNumeralBaseNotation == "maj" {
          builder.seventh = .major
        } else if nonNumeralBaseNotation == "°" || nonNumeralBaseNotation == "o" || nonNumeralBaseNotation == "dim" {
          builder.seventh = .diminished
        } else {
          builder.seventh = .dominant
        }
      case "9":
        builder.fill([.seventh])
        builder.addExtension(ChordExtensionType(type: .ninth))
      case "11":
        builder.fill([.seventh, .ninth])
        builder.addExtension(ChordExtensionType(type: .eleventh))
      case "13":
        builder.fill([.seventh, .ninth, .eleventh])
        builder.addExtension(ChordExtensionType(type: .thirteenth))
      default:
        fatalError()
      }

      let parsedExtendedNotation = regexMatches[2 ..< regexMatches.endIndex].compactMap { (extendedNotation) -> (modifier: String, scale: String)? in
        guard let extendedNotationRegex = try? NSRegularExpression(pattern: "(add|no|sus|♭|♯|#|b|maj|M|°|\\+)?\\s?(\\d+)?", options: []),
          let extendedNotationMatch = extendedNotationRegex.firstMatch(in: extendedNotation, options: [], range: NSRange(0 ..< extendedNotation.count)),
          let extendedNotationModifier = Range(extendedNotationMatch.range(at: 1), in: extendedNotation),
          let extendedNotationScale = Range(extendedNotationMatch.range(at: 2), in: extendedNotation) else {
          return nil
        }

        let modifier = String(extendedNotation[extendedNotationModifier])
        let scale = String(extendedNotation[extendedNotationScale])

        return (modifier, scale)
      }

      for (modifier, scale) in parsedExtendedNotation {
        switch modifier {
        case "":
          if scale.isEmpty == false {
            fatalError("Scale must be accompanied by add/sus/no modifier")
          }
        case "add":
          switch scale {
          case "6":
            builder.sixth = ChordSixthType()
          case "9": builder.addExtension(ChordExtensionType(type: .ninth))
          case "11": builder.addExtension(ChordExtensionType(type: .eleventh))
          default:
            fatalError("Invalid augmented scale")
          }
        case "no":
          switch scale {
          case "3":
            builder.third = nil
          case "5":
            builder.fifth = nil
          case "7":
            builder.seventh = nil
          case "9":
            builder.removeAllExtensions(ofType: .ninth)
          default:
            fatalError("Invalid augmented scale")
          }
        case "sus":
          switch scale {
          case "2":
            builder.suspended = .sus2
          case "4":
            builder.suspended = .sus4
          default:
            fatalError("Invalid suspension chord scale")
          }
        case "+", "♯", "#":
          switch scale {
          case "5":
            builder.fifth = .augmented
          case "9":
            builder.fill([.seventh])
            builder.addExtension(ChordExtensionType(type: .ninth, accidental: .sharp))
          case "11":
            builder.fill([.seventh, .ninth])
            builder.addExtension(ChordExtensionType(type: .eleventh, accidental: .sharp))
          default:
            fatalError("Invalid augmented scale")
          }
        case "°", "♭", "b":
          switch scale {
          case "5":
            builder.fifth = .diminished
          case "9":
            builder.fill([.seventh])
            builder.addExtension(ChordExtensionType(type: .ninth, accidental: .flat))
          case "11":
            builder.fill([.seventh, .ninth])
            builder.addExtension(ChordExtensionType(type: .eleventh, accidental: .flat))
          default:
            fatalError("Invalid diminished scale")
          }
        case "maj", "M":
          switch scale {
          case "7":
            builder.seventh = .major
          case "9":
            builder.fill([.seventh])
            builder.addExtension(ChordExtensionType(type: .ninth))
          case "11":
            builder.fill([.seventh, .ninth])
            builder.addExtension(ChordExtensionType(type: .eleventh, accidental: .flat))
          default:
            fatalError("Invalid major extension scale")
          }
        default:
          fatalError()
        }
      }
    }

    self.init(builder: builder)
  }

  // MARK: - ChordType

  /// Checks the equability between two `ChordType`s by their intervals.
  ///
  /// - Parameters:
  ///   - left: Left handside of the equation.
  ///   - right: Right handside of the equation.
  /// - Returns: Returns Bool value of equation of two given chord types.
  public static func == (left: ChordType, right: ChordType) -> Bool {
    return left.intervals == right.intervals
  }
}

public extension ChordType {
  public class Builder {
    public typealias BuilderBlock = (Builder) -> Void

    public var third: ChordThirdType? = .major
    public var fifth: ChordFifthType? = .perfect
    public var sixth: ChordSixthType?
    public var seventh: ChordSeventhType?
    public var suspended: ChordSuspendedType?
    public var extensions: [ChordExtensionType]?

    public init(builderBlock: BuilderBlock) {
      builderBlock(self)
    }

    public func addExtension(_ extension: ChordExtensionType) {
      if extensions == nil {
        extensions = [ChordExtensionType]()
      }
      extensions!.append(`extension`)
    }

    public func removeExtension(_ extension: ChordExtensionType) {
      guard var extensions = extensions, let index = extensions.index(of: `extension`) else {
        return
      }
      extensions.remove(at: index)
    }

    public func removeAllExtensions(ofType type: ChordExtensionType.ExtensionType) {
      extensions = extensions?.filter { (`extension`) -> Bool in
        `extension`.type != type
      }
    }

    public func addExtensionIfNoSameTypeExists(_ extension: ChordExtensionType) {
      if let extensions = extensions, extensions.contains(where: { $0.type == `extension`.type }) {
        return
      }
      addExtension(`extension`)
    }

    /// Options to fill in specified chord parts with defaults if they do not exist.
    struct FillOptions: OptionSet {
      let rawValue: Int

      static let seventh = FillOptions(rawValue: 1 << 0)
      static let ninth = FillOptions(rawValue: 1 << 1)
      static let eleventh = FillOptions(rawValue: 1 << 2)
      static let thirteenth = FillOptions(rawValue: 1 << 3)
    }

    func fill(_ autoFillOptions: FillOptions) {
      if autoFillOptions.contains(.thirteenth) {
        addExtensionIfNoSameTypeExists(ChordExtensionType(type: .thirteenth))
      } else if autoFillOptions.contains(.eleventh) {
        addExtensionIfNoSameTypeExists(ChordExtensionType(type: .eleventh))
      } else if autoFillOptions.contains(.ninth) {
        addExtensionIfNoSameTypeExists(ChordExtensionType(type: .ninth))
      } else if autoFillOptions.contains(.seventh) {
        if seventh == nil {
          seventh = .dominant
        }
      }
    }
  }

  public init(builder: Builder) {
    third = builder.third
    fifth = builder.fifth
    sixth = builder.sixth
    seventh = builder.seventh
    suspended = builder.suspended
    extensions = builder.extensions
  }
}

extension ChordType: ChordDescription {
  /// Notation of the chord type.
  public var notation: String {
    var seventhNotation = seventh?.notation ?? ""
    var sixthNotation = sixth == nil ? "" : "\(sixth!.notation)\(seventh == nil ? "" : "/")"
    let suspendedNotation = suspended?.notation ?? ""
    var extensionNotation = ""
    let ext = extensions?.sorted(by: { $0.type.rawValue < $1.type.rawValue }) ?? []

    var singleNotation = !ext.isEmpty && true
    for i in 0 ..< max(0, ext.count - 1) {
      if ext[i].accidental != .natural {
        singleNotation = false
      }
    }

    if singleNotation {
      extensionNotation = "(\(ext.last!.notation))"
    } else {
      extensionNotation = ext
        .compactMap({ $0.notation })
        .joined(separator: "/")
      extensionNotation = extensionNotation.isEmpty ? "" : "(\(extensionNotation))"
    }

    let thirdNotation: String
    let fifthNotation: String

    if let fifth = fifth, let third = third {
      thirdNotation = third.notation
      fifthNotation = fifth.notation
    } else if let fifth = fifth {
      thirdNotation = ""
      fifthNotation = fifth == .perfect ? "5" : fifth.notation
    } else if let third = third {
      thirdNotation = third.notation
      fifthNotation = "(no 5)"
    } else {
      thirdNotation = ""
      fifthNotation = ""
    }

    if seventh != nil {
      // Don't show major seventh note if extended is a major as well
      if seventh == .major, (extensions ?? []).count > 0 {
        seventhNotation = ""
        sixthNotation = sixth == nil ? "" : sixth!.notation
      }
      // Show fifth note after seventh in parenthesis
      if fifth == .augmented || fifth == .diminished {
        return "\(thirdNotation)\(sixthNotation)\(seventhNotation)(\(thirdNotation))\(suspendedNotation)\(extensionNotation)"
      }
    }

    return "\(thirdNotation)\(fifthNotation)\(sixthNotation)\(seventhNotation)\(suspendedNotation)\(extensionNotation)"
  }
}
