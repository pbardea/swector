//
//  main.swift
//  Swector
//
//  Created by Paul Bardea on 2016-05-10.
//  Copyright © 2016 pbardea. All rights reserved.
//

import Foundation

// Really testing
let u = Vector([1, 2, 3])
let v = Vector([4, 5, 6])

assert(u + v == Vector([5,7,9]))
assert(u - v == Vector([-3,-3,-3]))
assert(u ** v == 32)
assert(u * v == Vector([-3,6,-3]))

let A = Matrix([Vector([1,2,3]), Vector([4,5,6]), Vector([7,8,9])])

assert(A * A == Matrix([Vector([30, 36, 42]), Vector([66, 81, 96]), Vector([102, 126, 150])]))
print("Test completed")
