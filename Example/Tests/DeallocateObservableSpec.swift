//
//  DeallocateObservableSpec.swift
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

class DeallocateObservableSpec: QuickSpec {
    override class func spec() {
        var cancellables: [AnyCancellable]!
        var dummy: DummyDeallocateObservable?
        beforeEach {
            cancellables = []
            dummy = DummyDeallocateObservable()
        }
        it("should triggered when object deallocated") {
            var triggered1: Bool = false
            var triggered2: Bool = false
            
            dummy!.whenDeallocate {
                triggered1 = true
            }
            .store(in: &cancellables)
            dummy!.whenDeallocate {
                triggered2 = true
            }
            .store(in: &cancellables)
            
            dummy = nil
            
            expect(triggered1).to(beTrue())
            expect(triggered2).to(beTrue())
        }
    }
}

private class DummyDeallocateObservable: DeallocateObservable { }
