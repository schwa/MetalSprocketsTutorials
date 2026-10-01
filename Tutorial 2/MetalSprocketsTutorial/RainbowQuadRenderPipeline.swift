import Metal
import MetalSprockets
import simd

struct RainbowQuadRenderPipeline: Element {
    let library: ShaderLibrary

    // Two triangles forming a quad (6 vertices, 2 shared positions)
    let vertices: [Vertex] = [
        Vertex(position: [-0.75, -0.75], textureCoordinate: [0, 0]),
        Vertex(position: [0.75, -0.75], textureCoordinate: [1, 0]),
        Vertex(position: [0.75, 0.75], textureCoordinate: [1, 1]),
        Vertex(position: [-0.75, -0.75], textureCoordinate: [0, 0]),
        Vertex(position: [0.75, 0.75], textureCoordinate: [1, 1]),
        Vertex(position: [-0.75, 0.75], textureCoordinate: [0, 1]),
    ]

    init() throws {
        self.library = try ShaderLibrary(bundle: .main)
    }

    var body: some Element {
        get throws {
            try RenderPipeline(
                vertexShader: library.rainbowQuadVertexShader,
                fragmentShader: library.rainbowQuadFragmentShader
            ) {
                Draw { encoder in
                    encoder.drawPrimitives(primitiveType: .triangle, vertexStart: 0, vertexCount: 6)
                }
                .vertexValues(vertices, index: 0)
            }
            .vertexDescriptor(Vertex.descriptor)
        }
    }
}
