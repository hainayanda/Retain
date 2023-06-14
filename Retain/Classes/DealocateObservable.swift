//
//  DealocateObservable.swift
//  Retain
//
//  Created by Nayanda Haberty on 14/6/23.
//

import Foundation
import Combine

public protocol DealocateObservable: AnyObject {
    
    /// Return publisher that publish event of this object dealocation event
    /// - Returns: Publisher that publish event of this object dealocation event
    var dealocatePublisher: AnyPublisher<Void, Never> { get }

    /// Run this closure whenever this object is dealocated
    /// - Parameters:
    ///   - operation: Void closure that will be run when this object dealocated
    /// - Returns: AnyCancellable
    func whenDealocate(do operation: @escaping () -> Void) -> AnyCancellable
}

extension DealocateObservable {
    
    /// Return publisher that publish event of this object dealocation event
    /// - Returns: Publisher that publish event of this object dealocation event
    public var dealocatePublisher: AnyPublisher<Void, Never> {
        Retain.dealocatePublisher(of: self)
    }

    /// Run this closure whenever this object is dealocated
    /// - Parameters:
    ///   - operation: Void closure that will be run when this object dealocated
    /// - Returns: AnyCancellable
    public func whenDealocate(do operation: @escaping () -> Void) -> AnyCancellable {
        Retain.whenDealocate(for: self, do: operation)
    }
}
