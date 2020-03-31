// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// Transportation mode which can be used in the itinerary
public struct TransportMode: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - mode
  ///   - qualifier: Optional additional qualifier for transport mode, e.g. `RENT`
  public init(mode: Mode, qualifier: Swift.Optional<Qualifier?> = nil) {
    graphQLMap = ["mode": mode, "qualifier": qualifier]
  }

  public var mode: Mode {
    get {
      return graphQLMap["mode"] as! Mode
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mode")
    }
  }

  /// Optional additional qualifier for transport mode, e.g. `RENT`
  public var qualifier: Swift.Optional<Qualifier?> {
    get {
      return graphQLMap["qualifier"] as? Swift.Optional<Qualifier?> ?? Swift.Optional<Qualifier?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "qualifier")
    }
  }
}

public enum Mode: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// AIRPLANE
  case airplane
  /// BICYCLE
  case bicycle
  /// BUS
  case bus
  /// CABLE_CAR
  case cableCar
  /// CAR
  case car
  /// FERRY
  case ferry
  /// FUNICULAR
  case funicular
  /// GONDOLA
  case gondola
  /// Only used internally. No use for API users.
  case legSwitch
  /// RAIL
  case rail
  /// SUBWAY
  case subway
  /// TRAM
  case tram
  /// A special transport mode, which includes all public transport.
  case transit
  /// WALK
  case walk
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "AIRPLANE": self = .airplane
      case "BICYCLE": self = .bicycle
      case "BUS": self = .bus
      case "CABLE_CAR": self = .cableCar
      case "CAR": self = .car
      case "FERRY": self = .ferry
      case "FUNICULAR": self = .funicular
      case "GONDOLA": self = .gondola
      case "LEG_SWITCH": self = .legSwitch
      case "RAIL": self = .rail
      case "SUBWAY": self = .subway
      case "TRAM": self = .tram
      case "TRANSIT": self = .transit
      case "WALK": self = .walk
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .airplane: return "AIRPLANE"
      case .bicycle: return "BICYCLE"
      case .bus: return "BUS"
      case .cableCar: return "CABLE_CAR"
      case .car: return "CAR"
      case .ferry: return "FERRY"
      case .funicular: return "FUNICULAR"
      case .gondola: return "GONDOLA"
      case .legSwitch: return "LEG_SWITCH"
      case .rail: return "RAIL"
      case .subway: return "SUBWAY"
      case .tram: return "TRAM"
      case .transit: return "TRANSIT"
      case .walk: return "WALK"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Mode, rhs: Mode) -> Bool {
    switch (lhs, rhs) {
      case (.airplane, .airplane): return true
      case (.bicycle, .bicycle): return true
      case (.bus, .bus): return true
      case (.cableCar, .cableCar): return true
      case (.car, .car): return true
      case (.ferry, .ferry): return true
      case (.funicular, .funicular): return true
      case (.gondola, .gondola): return true
      case (.legSwitch, .legSwitch): return true
      case (.rail, .rail): return true
      case (.subway, .subway): return true
      case (.tram, .tram): return true
      case (.transit, .transit): return true
      case (.walk, .walk): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Mode] {
    return [
      .airplane,
      .bicycle,
      .bus,
      .cableCar,
      .car,
      .ferry,
      .funicular,
      .gondola,
      .legSwitch,
      .rail,
      .subway,
      .tram,
      .transit,
      .walk,
    ]
  }
}

/// Additional qualifier for a transport mode.
/// Note that qualifiers can only be used with certain transport modes.
public enum Qualifier: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// The vehicle used for transport can be rented
  case rent
  /// ~~HAVE~~
  /// **Currently not used**
  case have
  /// The vehicle used must be left to a parking area before continuing the journey.
  /// This qualifier is usable with transport modes `CAR` and `BICYCLE`.
  /// Note that the vehicle is only parked if the journey is continued with public
  /// transportation (e.g. if only `CAR` and `WALK` transport modes are allowed to
  /// be used, the car will not be parked as it is used for the whole journey).
  case park
  /// ~~KEEP~~
  /// **Currently not used**
  case keep
  /// The user can be picked up by someone else riding a vehicle
  case pickup
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "RENT": self = .rent
      case "HAVE": self = .have
      case "PARK": self = .park
      case "KEEP": self = .keep
      case "PICKUP": self = .pickup
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .rent: return "RENT"
      case .have: return "HAVE"
      case .park: return "PARK"
      case .keep: return "KEEP"
      case .pickup: return "PICKUP"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Qualifier, rhs: Qualifier) -> Bool {
    switch (lhs, rhs) {
      case (.rent, .rent): return true
      case (.have, .have): return true
      case (.park, .park): return true
      case (.keep, .keep): return true
      case (.pickup, .pickup): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Qualifier] {
    return [
      .rent,
      .have,
      .park,
      .keep,
      .pickup,
    ]
  }
}

public final class PlanQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Plan($fromPlace: String!, $toPlace: String!, $numItineraries: Int!, $transportModes: [TransportMode]!) {
      plan(fromPlace: $fromPlace, toPlace: $toPlace, numItineraries: $numItineraries, transportModes: $transportModes) {
        __typename
        itineraries {
          __typename
          walkDistance
          duration
          legs {
            __typename
            mode
            startTime
            endTime
            from {
              __typename
              lat
              lon
            }
            to {
              __typename
              lat
              lon
            }
            distance
            legGeometry {
              __typename
              length
              points
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Plan"

  public var fromPlace: String
  public var toPlace: String
  public var numItineraries: Int
  public var transportModes: [TransportMode?]

  public init(fromPlace: String, toPlace: String, numItineraries: Int, transportModes: [TransportMode?]) {
    self.fromPlace = fromPlace
    self.toPlace = toPlace
    self.numItineraries = numItineraries
    self.transportModes = transportModes
  }

  public var variables: GraphQLMap? {
    return ["fromPlace": fromPlace, "toPlace": toPlace, "numItineraries": numItineraries, "transportModes": transportModes]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["QueryType"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("plan", arguments: ["fromPlace": GraphQLVariable("fromPlace"), "toPlace": GraphQLVariable("toPlace"), "numItineraries": GraphQLVariable("numItineraries"), "transportModes": GraphQLVariable("transportModes")], type: .object(Plan.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(plan: Plan? = nil) {
      self.init(unsafeResultMap: ["__typename": "QueryType", "plan": plan.flatMap { (value: Plan) -> ResultMap in value.resultMap }])
    }

    /// Plans an itinerary from point A to point B based on the given arguments
    public var plan: Plan? {
      get {
        return (resultMap["plan"] as? ResultMap).flatMap { Plan(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "plan")
      }
    }

    public struct Plan: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Plan"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("itineraries", type: .nonNull(.list(.object(Itinerary.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(itineraries: [Itinerary?]) {
        self.init(unsafeResultMap: ["__typename": "Plan", "itineraries": itineraries.map { (value: Itinerary?) -> ResultMap? in value.flatMap { (value: Itinerary) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of possible itineraries
      public var itineraries: [Itinerary?] {
        get {
          return (resultMap["itineraries"] as! [ResultMap?]).map { (value: ResultMap?) -> Itinerary? in value.flatMap { (value: ResultMap) -> Itinerary in Itinerary(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Itinerary?) -> ResultMap? in value.flatMap { (value: Itinerary) -> ResultMap in value.resultMap } }, forKey: "itineraries")
        }
      }

      public struct Itinerary: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Itinerary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("walkDistance", type: .scalar(Double.self)),
          GraphQLField("duration", type: .scalar(String.self)),
          GraphQLField("legs", type: .nonNull(.list(.object(Leg.selections)))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(walkDistance: Double? = nil, duration: String? = nil, legs: [Leg?]) {
          self.init(unsafeResultMap: ["__typename": "Itinerary", "walkDistance": walkDistance, "duration": duration, "legs": legs.map { (value: Leg?) -> ResultMap? in value.flatMap { (value: Leg) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// How far the user has to walk, in meters.
        public var walkDistance: Double? {
          get {
            return resultMap["walkDistance"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "walkDistance")
          }
        }

        /// Duration of the trip on this itinerary, in seconds.
        public var duration: String? {
          get {
            return resultMap["duration"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "duration")
          }
        }

        /// A list of Legs. Each Leg is either a walking (cycling, car) portion of the
        /// itinerary, or a transit leg on a particular vehicle. So a itinerary where the
        /// user walks to the Q train, transfers to the 6, then walks to their
        /// destination, has four legs.
        public var legs: [Leg?] {
          get {
            return (resultMap["legs"] as! [ResultMap?]).map { (value: ResultMap?) -> Leg? in value.flatMap { (value: ResultMap) -> Leg in Leg(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Leg?) -> ResultMap? in value.flatMap { (value: Leg) -> ResultMap in value.resultMap } }, forKey: "legs")
          }
        }

        public struct Leg: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Leg"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("mode", type: .scalar(Mode.self)),
            GraphQLField("startTime", type: .scalar(String.self)),
            GraphQLField("endTime", type: .scalar(String.self)),
            GraphQLField("from", type: .nonNull(.object(From.selections))),
            GraphQLField("to", type: .nonNull(.object(To.selections))),
            GraphQLField("distance", type: .scalar(Double.self)),
            GraphQLField("legGeometry", type: .object(LegGeometry.selections)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(mode: Mode? = nil, startTime: String? = nil, endTime: String? = nil, from: From, to: To, distance: Double? = nil, legGeometry: LegGeometry? = nil) {
            self.init(unsafeResultMap: ["__typename": "Leg", "mode": mode, "startTime": startTime, "endTime": endTime, "from": from.resultMap, "to": to.resultMap, "distance": distance, "legGeometry": legGeometry.flatMap { (value: LegGeometry) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The mode (e.g. `WALK`) used when traversing this leg.
          public var mode: Mode? {
            get {
              return resultMap["mode"] as? Mode
            }
            set {
              resultMap.updateValue(newValue, forKey: "mode")
            }
          }

          /// The date and time when this leg begins. Format: Unix timestamp in milliseconds.
          public var startTime: String? {
            get {
              return resultMap["startTime"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startTime")
            }
          }

          /// The date and time when this leg ends. Format: Unix timestamp in milliseconds.
          public var endTime: String? {
            get {
              return resultMap["endTime"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endTime")
            }
          }

          /// The Place where the leg originates.
          public var from: From {
            get {
              return From(unsafeResultMap: resultMap["from"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "from")
            }
          }

          /// The Place where the leg ends.
          public var to: To {
            get {
              return To(unsafeResultMap: resultMap["to"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "to")
            }
          }

          /// The distance traveled while traversing the leg in meters.
          public var distance: Double? {
            get {
              return resultMap["distance"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "distance")
            }
          }

          /// The leg's geometry.
          public var legGeometry: LegGeometry? {
            get {
              return (resultMap["legGeometry"] as? ResultMap).flatMap { LegGeometry(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "legGeometry")
            }
          }

          public struct From: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Place"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("lat", type: .nonNull(.scalar(Double.self))),
              GraphQLField("lon", type: .nonNull(.scalar(Double.self))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(lat: Double, lon: Double) {
              self.init(unsafeResultMap: ["__typename": "Place", "lat": lat, "lon": lon])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Latitude of the place (WGS 84)
            public var lat: Double {
              get {
                return resultMap["lat"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lat")
              }
            }

            /// Longitude of the place (WGS 84)
            public var lon: Double {
              get {
                return resultMap["lon"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lon")
              }
            }
          }

          public struct To: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Place"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("lat", type: .nonNull(.scalar(Double.self))),
              GraphQLField("lon", type: .nonNull(.scalar(Double.self))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(lat: Double, lon: Double) {
              self.init(unsafeResultMap: ["__typename": "Place", "lat": lat, "lon": lon])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Latitude of the place (WGS 84)
            public var lat: Double {
              get {
                return resultMap["lat"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lat")
              }
            }

            /// Longitude of the place (WGS 84)
            public var lon: Double {
              get {
                return resultMap["lon"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "lon")
              }
            }
          }

          public struct LegGeometry: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Geometry"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("length", type: .scalar(Int.self)),
              GraphQLField("points", type: .scalar(String.self)),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(length: Int? = nil, points: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Geometry", "length": length, "points": points])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The number of points in the string
            public var length: Int? {
              get {
                return resultMap["length"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "length")
              }
            }

            /// List of coordinates of in a Google encoded polyline format (see
            /// https://developers.google.com/maps/documentation/utilities/polylinealgorithm)
            public var points: String? {
              get {
                return resultMap["points"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "points")
              }
            }
          }
        }
      }
    }
  }
}
