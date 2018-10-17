//
//  Note.swift
//  MusicTheorySwift
//
//  Created by Ben Lu on 10/15/18.
//

/// A protocol to provide duration counting. All conformists should expose countable duration in whole notes.
public protocol DurationMeasurable {
    /// Duration in whole notes
    var duration: Double { get }
}

public struct Rest {
    let noteValue: NoteValue
    
    public init(noteValue: NoteValue) {
        self.noteValue = noteValue
    }
}

public class Note {
    public let pitch: Pitch
    public let noteValue: NoteValue
    
    public init(pitch: Pitch, noteValue: NoteValue) {
        self.pitch = pitch
        self.noteValue = noteValue
    }
}

public class Passage: DurationMeasurable {
    public enum UngroupedPassageComponent: DurationMeasurable {
        case rest(Rest)
        case note(Note)
        
        public var duration: Double {
            switch self {
            case .rest(let rest):
                return rest.noteValue.duration
            case .note(let note):
                return note.noteValue.duration
            }
        }
    }
    
    public struct PassageComponent: DurationMeasurable {
        public struct Anchor {
            let uuid: UUID
            
            public init(uuid: UUID = UUID()) {
                self.uuid = uuid
            }
        }
        
        public let ungroupedComponent: UngroupedPassageComponent
        public let anchor: Anchor
        public weak var passage: Passage?
        
        public var duration: Double {
            return ungroupedComponent.duration
        }
        
        public init(ungroupedComponent: UngroupedPassageComponent) {
            self.ungroupedComponent = ungroupedComponent
            self.anchor = Anchor()
        }
    }
    
    let components: [UngroupedPassageComponent]
    
    public init(components: [UngroupedPassageComponent]) {
        self.components = components
    }
    
    public var duration: Double {
        return components.reduce(0.0, { $0 + $1.duration })
    }
}

public struct PitchGroup {
    public let pitches: [Pitch]
}

public struct RhythmGroup: DurationMeasurable {
    public let noteValues: [NoteValue]
    
    public var duration: Double {
        return noteValues.reduce(0.0, { $0 + $1.duration })
    }
    
    public func passage(byAssigningPitches pitches: [Pitch?]) -> Passage {
        assert(noteValues.count == pitches.count, "Number of the note values and pitches must agree")
        let components = zip(noteValues, pitches).map({ (noteValue, maybePitch) -> Passage.UngroupedPassageComponent in
            if let pitch = maybePitch {
                return .note(Note(pitch: pitch, noteValue: noteValue))
            } else {
                return .rest(Rest(noteValue: noteValue))
            }
        })
        return Passage(components: components)
    }
}
