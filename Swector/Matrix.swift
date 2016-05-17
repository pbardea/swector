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

    private var data: [Vector<Element>]
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
}

extension Matrix: SequenceType {
    typealias Generator = AnyGenerator<Vector<T>>

    func generate() -> Generator {
        var index = 0
        return AnyGenerator {
            if index < self.data.count {
                let d = self.data[index]
                index += 1
                return d
            }
            return nil
        }
    }

}

extension Matrix: Indexable, CollectionType {
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

    func mult(m: Matrix) -> Matrix {
        return Matrix()
    }

    func add(m: Matrix) -> Matrix {
        return Matrix(zip(self.data, m.data).map { $0 + $1 })
    }

    func subtract(m: Matrix) -> Matrix {
        return Matrix(zip(self.data, m.data).map { $0 - $1 })
    }

    func isSameSizeAs(m: Matrix) -> Bool {
        return self.size == m.size
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
