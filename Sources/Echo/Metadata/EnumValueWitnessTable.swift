//
//  EnumValueWitnessTable.swift
//  Echo
//
//  Created by Alejandro Alonso
//  Copyright © 2019 - 2020 Alejandro Alonso. All rights reserved.
//

/// The value witness table for enums that have enum specific value witness
/// functions.
public struct EnumValueWitnessTable: LayoutWrapper {
  typealias Layout = _EnumValueWitnessTable
  
  /// Backing enum value witness table pointer.
  public let ptr: UnsafeRawPointer
  
  var _enumVwt: _EnumValueWitnessTable {
    ptr.load(as: UnsafePointer<_EnumValueWitnessTable>.self).pointee
  }
  
  /// The base value witness table.
  public var vwt: ValueWitnessTable {
    ValueWitnessTable(ptr: ptr)
  }
  
  /// Given an instance of an enum, retrieve the "tag", the number that
  /// determines which case is currently being inhabited.
  /// - Parameter instance: An enum instance of the type this value witness
  ///                       resides in.
  /// - Returns: The tag number for which case is being inhabited.
  public func getEnumTag(for instance: UnsafeRawPointer) -> UInt32 {
    _enumVwt._getEnumTag(instance, vwt.trailing)
  }
  
  /// Given an instance of an enum, destructively remove the payload.
  /// - Parameter instance: An enum instance of the type this value witness
  ///                       resides in.
  public func destructiveProjectEnumData(for instance: UnsafeRawPointer) {
    _enumVwt._destructiveProjectEnumData(instance, vwt.trailing)
  }
  
  /// Given an instance of an enum and a case tag, destructively inject the tag
  /// into the enum instance.
  /// - Parameter instance: An enum instance of the type this value witness
  ///                       resides in.
  /// - Parameter tag: A case tag value within [0..numCases)
  public func destructiveInjectEnumTag(
    for instance: UnsafeRawPointer,
    tag: UInt32
  ) {
    _enumVwt._destructiveInjectEnumTag(instance, tag, vwt.trailing)
  }
}

struct _EnumValueWitnessTable {
  let _vwt: _ValueWitnessTable
  let _getEnumTag: @convention(c) (
    // Enum value
    UnsafeRawPointer,
    // Metadata
    UnsafeRawPointer
  ) -> UInt32 // returns the tag value (which case value in [0..numElements-1])
  let _destructiveProjectEnumData: @convention(c) (
    // Enum value
    UnsafeRawPointer,
    // Metadata
    UnsafeRawPointer
  ) -> ()
  let _destructiveInjectEnumTag: @convention(c) (
    // Enum value
    UnsafeRawPointer,
    // Tag
    UInt32,
    // Metadata
    UnsafeRawPointer
  ) -> ()
}
