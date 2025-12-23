import Metal
import simd

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

extension Vertex {
    static var descriptor: MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()

        // position: float3 at offset 0
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].offset = 0
        descriptor.attributes[0].bufferIndex = 0

        // color: float4 at offset 16 (SIMD3 has stride of 16, not 12)
        descriptor.attributes[1].format = .float4
        descriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        descriptor.attributes[1].bufferIndex = 0

        descriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return descriptor
    }
}

// MARK: - Cube Generation

/// Generates a unit cube (-1 to 1) with RGB colors based on vertex position.
func generateCubeVertices() -> [Vertex] {
    // Map position components to RGB: (-1,1) -> (0,1)
    func colorForPosition(_ p: SIMD3<Float>) -> SIMD4<Float> {
        let r = (p.x + 1) * 0.5
        let g = (p.y + 1) * 0.5
        let b = (p.z + 1) * 0.5
        return SIMD4<Float>(r, g, b, 1)
    }

    // Each face defined by 4 corners in counter-clockwise order (for correct culling)
    let faces: [[SIMD3<Float>]] = [
        [[-1, -1, 1], [1, -1, 1], [1, 1, 1], [-1, 1, 1]],       // Front +Z
        [[1, -1, -1], [-1, -1, -1], [-1, 1, -1], [1, 1, -1]],   // Back -Z
        [[-1, 1, 1], [1, 1, 1], [1, 1, -1], [-1, 1, -1]],       // Top +Y
        [[-1, -1, -1], [1, -1, -1], [1, -1, 1], [-1, -1, 1]],   // Bottom -Y
        [[1, -1, 1], [1, -1, -1], [1, 1, -1], [1, 1, 1]],       // Right +X
        [[-1, -1, -1], [-1, -1, 1], [-1, 1, 1], [-1, 1, -1]],   // Left -X
    ]

    // Build two triangles per face (6 vertices per face, 36 total)
    var vertices: [Vertex] = []
    for face in faces {
        vertices.append(Vertex(position: face[0], color: colorForPosition(face[0])))
        vertices.append(Vertex(position: face[1], color: colorForPosition(face[1])))
        vertices.append(Vertex(position: face[2], color: colorForPosition(face[2])))
        vertices.append(Vertex(position: face[0], color: colorForPosition(face[0])))
        vertices.append(Vertex(position: face[2], color: colorForPosition(face[2])))
        vertices.append(Vertex(position: face[3], color: colorForPosition(face[3])))
    }
    return vertices
}
