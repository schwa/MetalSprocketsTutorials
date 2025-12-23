import simd
import Foundation

extension float4x4 {
    /// Creates a translation matrix
    static func translation(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
        float4x4(columns: (
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(x, y, z, 1)
        ))
    }

    /// Creates a standard perspective projection matrix
    static func perspective(fovY: Float, aspect: Float, near: Float, far: Float) -> float4x4 {
        let y = 1 / tan(fovY * 0.5)
        let x = y / aspect
        let z = far / (near - far)
        let w = (near * far) / (near - far)
        return float4x4(columns: (
            SIMD4<Float>(x, 0, 0, 0),
            SIMD4<Float>(0, y, 0, 0),
            SIMD4<Float>(0, 0, z, -1),
            SIMD4<Float>(0, 0, w, 0)
        ))
    }
}

/// Creates a tumbling rotation matrix for the spinning cube animation
func cubeRotationMatrix(time: TimeInterval) -> float4x4 {
    let rotationY = float4x4(simd_quatf(angle: Float(time), axis: [0, 1, 0]))
    let rotationX = float4x4(simd_quatf(angle: Float(time) * 0.7, axis: [1, 0, 0]))
    return rotationX * rotationY
}
