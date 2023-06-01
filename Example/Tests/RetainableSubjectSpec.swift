//
//  RetainableSubjectSpec.swift
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

class RetainableSubjectSpec: QuickSpec {
    override class func spec() {
        var cancellables: [AnyCancellable]!
        var subject: RetainableSubject<Dummy>!
        beforeEach {
            cancellables = []
            subject = .init()
        }
        context("weak") {
            beforeEach {
                subject.makeWeak()
            }
            it("should retain the value weakly") {
                var dummy: Dummy? = Dummy()
                subject.wrappedValue = dummy
                
                expect(subject.wrappedValue).notTo(beNil())
                expect(subject.wrappedValue === dummy).to(beTrue())
                
                dummy = nil
                
                expect(subject.wrappedValue).to(beNil())
            }
            it("should retain the value strongly if changed from weak to strong") {
                var dummy: Dummy? = Dummy()
                subject.wrappedValue = dummy
                
                expect(subject.wrappedValue).notTo(beNil())
                expect(subject.wrappedValue === dummy).to(beTrue())
                
                subject.makeStrong()
                dummy = nil
                
                expect(subject.wrappedValue).notTo(beNil())
            }
            it("should published dealocate event") {
                var dummy: Dummy? = Dummy()
                subject.wrappedValue = dummy
                
                var triggered: Bool = false
                subject.projectedValue.publisher.sink {
                    triggered = true
                }
                .store(in: &cancellables)
                
                dummy = nil
                
                expect(triggered).to(beTrue())
            }
        }
        context("strong") {
            beforeEach {
                subject.projectedValue.makeStrong()
            }
            it("should retain the value strongly") {
                var dummy: Dummy? = Dummy()
                subject.wrappedValue = dummy
                
                expect(subject.wrappedValue).notTo(beNil())
                expect(subject.wrappedValue === dummy).to(beTrue())
                
                dummy = nil
                
                expect(subject.wrappedValue).notTo(beNil())
            }
            it("should retain the value weakly if changed from strong to weak") {
                var dummy: Dummy? = Dummy()
                subject.wrappedValue = dummy
                
                expect(subject.wrappedValue).notTo(beNil())
                expect(subject.wrappedValue === dummy).to(beTrue())
                
                subject.makeWeak()
                dummy = nil
                
                expect(subject.wrappedValue).to(beNil())
            }
            it("should published dealocate event when change to weak and dealocated") {
                var dummy: Dummy? = Dummy()
                subject.wrappedValue = dummy
                
                var triggered: Bool = false
                subject.projectedValue.publisher.sink {
                    triggered = true
                }
                .store(in: &cancellables)
                
                dummy = nil
                
                expect(triggered).to(beFalse())
                
                subject.makeWeak()
                
                expect(triggered).to(beTrue())
            }
        }
    }
}
