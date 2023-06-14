//
//  DeallocateFunctionSpec.swift
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

class DeallocateFunctionSpec: QuickSpec {
    override class func spec() {
        var cancellables: [AnyCancellable]!
        var dummy: Dummy?
        beforeEach {
            cancellables = []
            dummy = Dummy()
        }
        it("should triggered when object deallocated") {
            var triggered1: Bool = false
            var triggered2: Bool = false
            
            whenDeallocate(for: dummy!) {
                triggered1 = true
            }
            .store(in: &cancellables)
            whenDeallocate(for: dummy!) {
                triggered2 = true
            }
            .store(in: &cancellables)
            
            dummy = nil
            
            expect(triggered1).to(beTrue())
            expect(triggered2).to(beTrue())
        }
    }
}
