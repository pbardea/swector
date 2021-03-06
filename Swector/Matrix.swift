//
//  Matrix.swift
//  Swector
//
//  Created by Paul Bardea on 2016-05-10.
//  Copyright © 2016 pbardea. All rights reserved.
//

import Foundation

struct Matrix<T: Numeric> {
    typealias Element = T

    fileprivate var data: [Vector<Element>]
    var size: (Int, Int) {
        return (self.data.count, self.data.first?.size ?? 0)
    }

    subscript(index: Int) -> Vector<Element> {
        assert(index < self.data.count && index >= 0)
        return data[index]
    }

    init(_ data: [Vector<Element>] = []) {
        self.data = data
    }

    init(_ data: [[Element]] = []) {
        self.data = data.map { d in Vector(d) }
    }
}

extension Matrix: Sequence {
    typealias Iterator = AnyIterator<Vector<T>>

    func makeIterator() -> Iterator {
        var index = 0
        return AnyIterator {
            if index < self.data.count {
                let d = self.data[index]
                index += 1
                return d
            }
            return nil
        }
    }

}

extension Matrix {

    func getRow(_ row: Int) -> Vector<Element> {
        return self.data[row]
    }

    func getColumn(_ column: Int) -> Vector<Element> {
        return Vector(self.data.map { v in
            v[column]
        })
    }

}

extension Matrix: Collection {
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
    typealias _Element = Vector<T>

    subscript(index: Int) -> Element? {
        let (_, width) = self.size

        if width > 0 {
            let x = index % width
            let y = index / width

            return self.data[y][x]
        }
        return nil
    }

    var startIndex: Int { return 0 }
    var endIndex: Int {
        let (h, w) = self.size
        return h * w - 1
    }
}

private extension Matrix {

    func mult(_ m: Matrix) -> Matrix {
        assert(self.data.count > 0)
        return Matrix((0..<self.data.count).map { i in
            (0..<m.data[0].size).map { j in
                self.getRow(i) ** m.getColumn(j)
            }
        })
    }

    func add(_ m: Matrix) -> Matrix {
        return Matrix(zip(self.data, m.data).map { $0 + $1 })
    }

    func subtract(_ m: Matrix) -> Matrix {
        return Matrix(zip(self.data, m.data).map { $0 - $1 })
    }

    func isSameSizeAs(_ m: Matrix) -> Bool {
        return self.size == m.size
    }
}

extension Matrix: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
        return lhs.data == rhs.data
    }

}

func + <T: Numeric>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return lhs.add(rhs)
}

func - <T: Numeric>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return lhs.subtract(rhs)
}

func * <T: Numeric>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return lhs.mult(rhs)
}
