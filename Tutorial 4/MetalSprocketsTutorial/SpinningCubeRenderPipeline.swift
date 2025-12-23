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
            try RenderPipeline(
                vertexShader: library.cubeVertexShader,
                fragmentShader: library.cubeFragmentShader
            ) {
                Draw { encoder in
                    // Pass uniforms to vertex shader
                    var uniforms = uniforms
                    encoder.setVertexBytes(
                        &uniforms,
                        length: MemoryLayout<Uniforms>.stride,
                        index: 1
                    )

                    // Generate and pass cube vertices
                    var vertices = generateCubeVertices()
                    encoder.setVertexBytes(
                        &vertices,
                        length: MemoryLayout<Vertex>.stride * vertices.count,
                        index: 0
                    )
                    encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
                }
            }
            .vertexDescriptor(Vertex.descriptor)
            // Enable depth testing so back faces don't render over front faces
            .depthCompare(function: .less, enabled: true)
        }
    }
}
