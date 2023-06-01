//
//  WeakSubjectSpec.swift
//  Retain_Tests
//
//  Created by Nayanda Haberty on 1/6/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Retain
import Combine

class WeakSubjectSpec: QuickSpec {
    override class func spec() {
        var cancellables: [AnyCancellable]!
        var subject: WeakSubject<Dummy>!
        beforeEach {
            cancellables = []
            subject = .init()
        }
        it("should retain the value weakly") {
            var dummy: Dummy? = Dummy()
            subject.wrappedValue = dummy
            
            expect(subject.wrappedValue).notTo(beNil())
            expect(subject.wrappedValue === dummy).to(beTrue())
            
            dummy = nil
            
            expect(subject.wrappedValue).to(beNil())
        }
        it("should published dealocate event") {
            var dummy: Dummy? = Dummy()
            subject.wrappedValue = dummy
            
            var triggered: Bool = false
            subject.projectedValue.sink {
                triggered = true
            }
            .store(in: &cancellables)
            
            dummy = nil
            
            expect(triggered).to(beTrue())
        }
    }
}
