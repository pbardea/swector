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
    fileprivate var data: [Element]
    var size: Int {
        get {
            return self.data.count
        }
    }

    init(_ data: [Element] = []) {
        self.data = data
    }

}

extension Vector: Sequence {
    typealias Iterator = AnyIterator<T>

    func makeIterator() -> Iterator {
        var index = 0
        return AnyIterator {
            index += 1
            return index < self.data.count ? self.data[index-1] : nil
        }
    }

}

extension Vector: Collection {
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        guard i != endIndex else { fatalError("Cannot increment endIndex") }
        return i + 1
    }


    typealias Index = Int

    subscript(index: Int) -> Element {
        return self.data[index]
    }

    var startIndex: Int { return 0 }
    var endIndex: Int { return self.data.count - 1 }
}

private extension Vector {

    func add(_ v: Vector) -> Vector {
        return Vector(zip(self.data, v.data).map(+))
    }

    func subtract(_ v: Vector) -> Vector {
        return Vector(zip(self.data, v.data).map(-))
    }

    func dot(_ v: Vector) -> Element {
        return zip(self.data, v.data).map(*).reduce(Element(0), +)
    }

    func cross(_ v: Vector) -> Vector {
        assert(self.size == v.size)
        var product = Vector()
        for i in 0..<self.size {
            let first = (i+1) % self.size
            let second = (i+2) % self.size
            let nextElement = self.data[first]*v.data[second]-v.data[first]*self.data[second]
            let newData: [T] = product.data + [nextElement]
            product = Vector(newData)
        }
        return product
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

// Dot
infix operator ** { associativity left precedence 160 }

func ** <T: Numeric>(lhs: Vector<T>, rhs: Vector<T>) -> T {
    return lhs.dot(rhs)
}

// Debugging
extension Vector: CustomStringConvertible {
    var description: String {
        return self.data.description
    }
}
