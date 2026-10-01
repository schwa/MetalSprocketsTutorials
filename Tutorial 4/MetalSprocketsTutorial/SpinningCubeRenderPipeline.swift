import Metal
import MetalSprockets
import simd

/// Uniforms struct matching the Metal shader - contains our 3 transformation matrices
struct Uniforms {
    var modelMatrix: float4x4
    var viewMatrix: float4x4
    var projectionMatrix: float4x4
}

struct SpinningCubeRenderPipeline: Element {
    let library: ShaderLibrary
    let uniforms: Uniforms

    init(uniforms: Uniforms) throws {
        self.library = try ShaderLibrary(bundle: .main)
        self.uniforms = uniforms
    }

    var body: some Element {
        get throws {
            let vertices = generateCubeVertices()
            return try RenderPipeline(
                vertexShader: library.cubeVertexShader,
                fragmentShader: library.cubeFragmentShader
            ) {
                Draw { encoder in
                    encoder.drawPrimitives(primitiveType: .triangle, vertexStart: 0, vertexCount: vertices.count)
                }
                .vertexValues(vertices, index: 0)
                .vertexValues([uniforms], index: 1)
            }
            .vertexDescriptor(Vertex.descriptor)
            // Enable depth testing so back faces don't render over front faces
            .depthCompare(function: .less, enabled: true)
        }
    }
}
