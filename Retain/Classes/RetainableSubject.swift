//
//  RetainableSubject.swift
//  Retain
//
//  Created by Nayanda Haberty on 1/6/23.
//

import Foundation
import Combine

public protocol RetainControllable: AnyObject {
    var state: RetainState { get set }
    var publisher: AnyPublisher<Void, Never> { get }
}

public enum RetainState {
    case strong
    case `weak`
}

extension RetainControllable {
    public func makeWeak() {
        state = .weak
    }
    
    public func makeStrong() {
        state = .strong
    }
}

@propertyWrapper
public final class RetainableSubject<Wrapped: AnyObject>: RetainControllable {
    
    public var publisher: AnyPublisher<Void, Never> { $weakWrappedValue }
    
    @WeakSubject private var weakWrappedValue: Wrapped?
    private var strongWrappedValue: Wrapped?
    public var wrappedValue: Wrapped? {
        get { weakWrappedValue }
        set {
            weakWrappedValue = newValue
            guard state == .strong else { return }
            strongWrappedValue = newValue
        }
    }
    
    public var state: RetainState {
        didSet {
            switch state {
            case .strong:
                strongWrappedValue = weakWrappedValue
            case .weak:
                strongWrappedValue = nil
            }
        }
    }
    
    public init(wrappedValue: Wrapped? = nil, state: RetainState = .strong) {
        self.state = state
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: RetainControllable { self }
}
