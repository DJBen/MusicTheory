//
//  Passage.swift
//  MusicTheory
//
//  Created by Sihao Lu on 11/9/18.
//  Copyright © 2018 cemolcay. All rights reserved.
//

public class Passage: DurationMeasurable {
  public struct Configuration {}

  public enum Component: DurationMeasurable {
    case rest(Rest)
    case note(Note)

    public var duration: Double {
      switch self {
      case let .rest(rest):
        return rest.noteValue.duration
      case let .note(note):
        return note.noteValue.duration
      }
    }
  }

  public struct AnchoredComponent: DurationMeasurable {
    public struct Anchor {
      let uuid: UUID

      public init(uuid: UUID = UUID()) {
        self.uuid = uuid
      }
    }

    public let component: Component
    public let anchor: Anchor

    public var duration: Double {
      return component.duration
    }

    public init(component: Component) {
      self.component = component
      anchor = Anchor()
    }
  }

  let anchoredComponents: [AnchoredComponent]

  public init(components: [Component]) {
    anchoredComponents = components.map { AnchoredComponent(component: $0) }
  }

  public var duration: Double {
    return anchoredComponents.reduce(0.0, { $0 + $1.duration })
  }
}
