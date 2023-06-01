//
//  DealocateListener.swift
//  Retain
//
//  Created by Nayanda Haberty on 1/6/23.
//

import Foundation
import Combine

private var retainDealocateKey: String = "retainDealocateKey"

/// Return publisher that publish event of the given object dealocation event
/// - Parameter object: Object
/// - Returns: Publisher that publish event of the given object dealocation event
public func dealocatePublisher<D: AnyObject>(of object: D) -> AnyPublisher<Void, Never> {
    guard let holder = objc_getAssociatedObject(object, &retainDealocateKey) as? DealocatePublisherHolder else {
        let newHolder = DealocatePublisherHolder()
        objc_setAssociatedObject(object, &retainDealocateKey, newHolder, .OBJC_ASSOCIATION_RETAIN)
        return newHolder.publisher.eraseToAnyPublisher()
    }
    return holder.publisher.eraseToAnyPublisher()
}

/// Run the given closure whenever the given object is dealocated
/// - Parameters:
///   - object: Object
///   - operation: Void closure that will be run when the given object dealocated
/// - Returns: AnyCancellable
public func whenDealocate<D: AnyObject>(for object: D, do operation: @escaping () -> Void) -> AnyCancellable {
    return dealocatePublisher(of: object).sink(receiveValue: operation)
}

// MARK: DealocatePublisherHolder

private class DealocatePublisherHolder {
    let publisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    deinit {
        publisher.send(())
        publisher.send(completion: .finished)
    }
}
