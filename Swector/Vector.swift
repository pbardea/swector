//
//  Vector.swift
//  Swector
//
//  Created by Paul Bardea on 2016-05-10.
//  Copyright © 2016 pbardea. All rights reserved.
//

import Foundation

struct Vector<T: Numeric> {
    typealias Element = T
    private var data: [Element]
    var size: Int {
        get {
            return self.data.count
        }
    }

    init(_ data: [Element] = []) {
        self.data = data
    }

}

extension Vector: SequenceType {
    typealias Generator = AnyGenerator<T>

    func generate() -> Generator {
        var index = 0
        return AnyGenerator {
            index += 1
            return index < self.data.count ? self.data[index-1] : nil
        }
    }

}

extension Vector: CollectionType {
    typealias Index = Int

    subscript(index: Int) -> Element {
        return self.data[index]
    }

    var startIndex: Int { return 0 }
    var endIndex: Int { return self.data.count - 1 }
}

private extension Vector {

    func add(v: Vector) -> Vector {
        return Vector(zip(self.data, v.data).map { $0 + $1 })
    }

    func subtract(v: Vector) -> Vector {
        return Vector(zip(self.data, v.data).map { $0 - $1 })
    }

    func dot(v: Vector) -> Element {
        return zip(self.data, v.data).map({ $0 * $1 }).reduce(Element(0), combine: +)
    }

    func cross(v: Vector) -> Vector {
        return Vector() // TODO: implement me
    }

}

// Add
func + <T: Numeric>(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
    return lhs.add(rhs)
}

// Subtract
func - <T: Numeric>(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
    return lhs.subtract(rhs)
}

// Times
func * <T: Numeric>(lhs: Vector<T>, rhs: Vector<T>) -> Vector<T> {
    return lhs.cross(rhs)
}
