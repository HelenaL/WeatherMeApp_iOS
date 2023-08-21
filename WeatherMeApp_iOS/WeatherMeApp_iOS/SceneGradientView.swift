//
//  SceneGradientView.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 8/17/23.
//

import Foundation
import UIKit
import simd
import SceneKit

//struct ControlPoint {
//    var color: simd_float3 = simd_float3(0, 0, 0)
//
//    var location: simd_float2 = simd_float2(0, 0)
//    var uTangent: simd_float2 = simd_float2(0, 0)
//    var vTangent: simd_float2 = simd_float2(0, 0)
//}
//
//class SceneGradientView: SCNView {
//
//   let H = simd_float4x4(rows: [
//        simd_float4( 2, -2,  1,  1),
//        simd_float4(-3,  3, -2, -1),
//        simd_float4( 0,  0,  1,  0),
//        simd_float4( 1,  0,  0,  0)
//    ])
//
////    var H_T = H.transpose
//
//    func surfacePoint(
//        u: Float,
//        v: Float,
//        X: simd_float4x4,
//        Y: simd_float4x4
//    ) -> simd_float2 {
//
//        let H_T = H.transpose
//        let U = simd_float4(u * u * u, u * u, u, 1)
//        let V = simd_float4(v * v * v, v * v, v, 1)
//
//        return simd_float2(
//            dot(V, U * H * X * H.transpose),
//            dot(V, U * H * Y * H.transpose)
//        )
//    }
//
//    func meshCoefficients(
//        _ p00: ControlPoint,
//        _ p01: ControlPoint,
//        _ p10: ControlPoint,
//        _ p11: ControlPoint,
//        axis: KeyPath<simd_float2, Float>
//    ) -> simd_float4x4 {
//        func l(_ controlPoint: ControlPoint) -> Float {
//            controlPoint.location[keyPath: axis]
//        }
//
//        func u(_ controlPoint: ControlPoint) -> Float {
//            controlPoint.uTangent[keyPath: axis]
//        }
//
//        func v(_ controlPoint: ControlPoint) -> Float {
//            controlPoint.vTangent[keyPath: axis]
//        }
//
//        return simd_float4x4(rows: [
//            simd_float4(l(p00), l(p01), v(p00), v(p01)),
//            simd_float4(l(p10), l(p11), v(p10), v(p11)),
//            simd_float4(u(p00), u(p01),      0,      0),
//            simd_float4(u(p10), u(p11),      0,      0)
//        ])
//    }
//
//    func colorCoefficients(
//        _ p00: ControlPoint,
//        _ p01: ControlPoint,
//        _ p10: ControlPoint,
//        _ p11: ControlPoint,
//        axis: KeyPath<simd_float3, Float>
//    ) -> simd_float4x4 {
//        func l(_ point: ControlPoint) -> Float {
//            point.color[keyPath: axis]
//        }
//
//        return simd_float4x4(rows: [
//            simd_float4(l(p00), l(p01), 0, 0),
//            simd_float4(l(p10), l(p11), 0, 0),
//            simd_float4(     0,      0, 0, 0),
//            simd_float4(     0,      0, 0, 0)
//        ])
//    }
//
//    func colorPoint(
//        u: Float,
//        v: Float,
//        R: simd_float4x4,
//        G: simd_float4x4,
//        B: simd_float4x4
//    ) -> simd_float3 {
//        let U = simd_float4(u * u * u, u * u, u, 1)
//        let V = simd_float4(v * v * v, v * v, v, 1)
//
//        return simd_float3(
//            dot(V, U * H * R * H.transpose),
//            dot(V, U * H * G * H.transpose),
//            dot(V, U * H * B * H.transpose)
//        )
//    }
//
//    func bilinearInterpolation(u: Float, v: Float, _ c00: ControlPoint, _ c01: ControlPoint, _ c10: ControlPoint, _ c11: ControlPoint) -> simd_float3 {
//        let r = simd_float2x2(rows: [
//            simd_float2(c00.color.x, c01.color.x),
//            simd_float2(c10.color.x, c11.color.x),
//        ])
//
//        let g = simd_float2x2(rows: [
//            simd_float2(c00.color.y, c01.color.y),
//            simd_float2(c10.color.y, c11.color.y),
//        ])
//
//        let b = simd_float2x2(rows: [
//            simd_float2(c00.color.z, c01.color.z),
//            simd_float2(c10.color.z, c11.color.z),
//        ])
//
//        let r_ = dot(simd_float2(1 - u, u), r * simd_float2(1 - v, v))
//        let g_ = dot(simd_float2(1 - u, u), g * simd_float2(1 - v, v))
//        let b_ = dot(simd_float2(1 - u, u), b * simd_float2(1 - v, v))
//
//        return simd_float3(r_, g_, b_)
//    }
//
//    public func lerp<S: SignedNumeric>(_ f: S, _ min: S, _ max: S) -> S {
//        min + f * (max - min)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//
//
//    }
//
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        var grid = Grid(repeating: ControlPoint(), width: 3, height: 3)
//        grid[0, 0].color = simd_float3(0.955, 0.015, 0.074)
//        grid[0, 1].color = simd_float3(0.913, 0.005, 0.346)
//        grid[0, 2].color = simd_float3(0.904, 0.001, 0.012)
//
//        grid[1, 0].color = simd_float3(0.042, 0.135, 0.799)
//        grid[1, 1].color = simd_float3(0.127, 0.104, 0.791)
//        grid[1, 2].color = simd_float3(0.024, 0.007, 0.904)
//
//        grid[2, 0].color = simd_float3(0.921, 0.955, 0.000)
//        grid[2, 1].color = simd_float3(0.000, 0.921, 0.610)
//        grid[2, 2].color = simd_float3(0.019, 0.007, 0.913)
//
//        for y in 0 ..< grid.height {
//            for x in 0 ..< grid.width {
//                grid[x, y].location = simd_float2(
//                    lerp(Float(x) / Float(grid.width  - 1), -1, 1),
//                    lerp(Float(y) / Float(grid.height - 1), -1, 1)
//                )
//
//                grid[x, y].uTangent.x = 2 / Float(grid.width  - 1)
//                grid[x, y].vTangent.y = 2 / Float(grid.height - 1)
//
//                // Try randomizing the grid:
//                //
//                //     grid[x, y].uTangent.x += .random(in: -1.5 ... 1.5)
//                //     grid[x, y].uTangent.y += .random(in: -1.5 ... 1.5)
//                //     grid[x, y].vTangent.x += .random(in: -1.5 ... 1.5)
//                //     grid[x, y].vTangent.y += .random(in: -1.5 ... 1.5)
//                //
//            }
//        }
//
//        let subdivisions = 15
//
//        var points = Grid(
//            repeating: simd_float2(0, 0),
//            width: (grid.width - 1) * subdivisions,
//            height: (grid.height - 1) * subdivisions
//        )
//
//        var colors = Grid(
//            repeating: simd_float3(0, 0 , 0),
//            width: (grid.width - 1) * subdivisions,
//            height: (grid.height - 1) * subdivisions
//        )
//
//        for x in 0 ..< grid.width - 1 {
//            for y in 0 ..< grid.height - 1 {
//                // The four control points in the corners of the current patch.
//                let p00 = grid[    x,     y]
//                let p01 = grid[    x, y + 1]
//                let p10 = grid[x + 1,     y]
//                let p11 = grid[x + 1, y + 1]
//
//                // The X and Y coefficient matrices for the current Hermite patch.
//                let X = meshCoefficients(p00, p01, p10, p11, axis: \.x)
//                let Y = meshCoefficients(p00, p01, p10, p11, axis: \.y)
//
//                // The coefficients matrices for the current hermite patch in RGB
//                // space
//                let R = colorCoefficients(p00, p01, p10, p11, axis: \.x)
//                let G = colorCoefficients(p00, p01, p10, p11, axis: \.y)
//                let B = colorCoefficients(p00, p01, p10, p11, axis: \.z)
//
//                for u in 0 ..< subdivisions {
//                    for v in 0 ..< subdivisions {
//                        points[x * subdivisions + u, y * subdivisions + v] =
//                        surfacePoint(
//                            u: Float(u) / Float(subdivisions - 1),
//                            v: Float(v) / Float(subdivisions - 1),
//                            X: X,
//                            Y: Y
//                        )
//
//                        // Compare against bilinear interpolation here by using
//                        //
//                        //     bilinearInterpolation(
//                        //         u: Float(u) / Float(subdivisions - 1),
//                        //         v: Float(v) / Float(subdivisions - 1),
//                        //         c00, c01, c10, c11)
//                        //
//                        colors[x * subdivisions + u, y * subdivisions + v] =
//                        colorPoint(
//                            u: Float(u) / Float(subdivisions - 1),
//                            v: Float(v) / Float(subdivisions - 1),
//                            R: R, G: G, B: B
//                        )
//                    }
//                }
//
//            }
//        }
//
//        //let scene = SCNScene(coder: <#T##NSCoder#>)
//        let node = SCNNode(points: points, colors: colors)
//        self.scene?.rootNode.addChildNode(node)
//    }
//
//}
//
//public extension SCNNode {
//    /// Creates a `SCNNode` based on a `Grid` of 2D points and a `Grid` of
//    /// colors.
//    convenience init(points: Grid<simd_float2>, colors: Grid<simd_float3>) {
//        precondition(points.width == colors.width && points.height == colors.height, "Grids must be of the same size.")
//
//        var vertexList: [simd_float3] = []
//        var colorList: [simd_float3] = []
//
//        for x in 0 ..< points.width - 1 {
//            for y in 0 ..< points.height - 1 {
//                let p00 = points[x    , y    ]
//                let p10 = points[x + 1, y    ]
//                let p01 = points[x    , y + 1]
//                let p11 = points[x + 1, y + 1]
//
//                let v00 = simd_float3(p00.x, p00.y, 0)
//                let v10 = simd_float3(p10.x, p10.y, 0)
//                let v01 = simd_float3(p01.x, p01.y, 0)
//                let v11 = simd_float3(p11.x, p11.y, 0)
//
//                let c1 = colors[x    , y    ]
//                let c2 = colors[x + 1, y    ]
//                let c3 = colors[x    , y + 1]
//                let c4 = colors[x + 1, y + 1]
//
//                vertexList.append(contentsOf: [
//                    v00, v10, v11,
//
//                    v11, v01, v00
//                ])
//
//                colorList.append(contentsOf: [
//                    c1, c2, c4,
//
//                    c4, c3, c1
//                ])
//            }
//        }
//
//        let indices = vertexList.indices.map(Int32.init)
//
//        let elements = SCNGeometryElement(indices: indices, primitiveType: .triangles)
//
//        self.init(
//            geometry: SCNGeometry(
//                sources: [
//                    SCNGeometrySource(vertices: vertexList.map { SCNVector3($0) }),
//                    SCNGeometrySource(colors: colorList.map { SCNVector3($0) })
//                ],
//                elements: [elements]
//            )
//        )
//    }
//}
//
//public struct Grid<Element> {
//    public var elements: ContiguousArray<Element>
//
//    public var width: Int
//
//    public var height: Int
//
//    public init(repeating element: Element, width: Int, height: Int) {
//        self.width = width
//        self.height = height
//        self.elements = ContiguousArray(repeating: element, count: width * height)
//    }
//
//    public subscript(x: Int, y: Int) -> Element {
//        get {
//            elements[x + y * width]
//        }
//        set {
//            elements[x + y * width] = newValue
//        }
//    }
//}
//
//extension Grid: Equatable where Element: Equatable {}
//
//extension Grid: Hashable where Element: Hashable {}
//
//public extension SCNGeometrySource {
//    /// Initializes a `SCNGeometrySource` with a list of colors as
//    /// `SCNVector3`s`.
//    convenience init(colors: [SCNVector3]) {
//        let colorData = Data(bytes: colors, count: MemoryLayout<SCNVector3>.size * colors.count)
//
//        self.init(
//            data: colorData,
//            semantic: .color,
//            vectorCount: colors.count,
//            usesFloatComponents: true,
//            componentsPerVector: 3,
//            bytesPerComponent: MemoryLayout<Float>.size,
//            dataOffset: 0,
//            dataStride: MemoryLayout<SCNVector3>.size
//        )
//    }
//}


