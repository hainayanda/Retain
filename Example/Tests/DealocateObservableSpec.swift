//
//  DealocateObservableSpec.swift
//  Retain_Tests
//
//  Created by Nayanda Haberty on 14/6/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Retain
import Combine

class DealocateObservableSpec: QuickSpec {
    override class func spec() {
        var cancellables: [AnyCancellable]!
        var dummy: DummyDealocateObservable?
        beforeEach {
            cancellables = []
            dummy = DummyDealocateObservable()
        }
        it("should triggered when object dealocated") {
            var triggered1: Bool = false
            var triggered2: Bool = false
            
            dummy!.whenDealocate {
                triggered1 = true
            }
            .store(in: &cancellables)
            dummy!.whenDealocate {
                triggered2 = true
            }
            .store(in: &cancellables)
            
            dummy = nil
            
            expect(triggered1).to(beTrue())
            expect(triggered2).to(beTrue())
        }
    }
}

private class DummyDealocateObservable: DealocateObservable { }
