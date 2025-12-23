import MetalSprockets
import MetalSprocketsUI
import SwiftUI

struct ContentView: View {
    let library = try! ShaderLibrary(bundle: .main)

    var body: some View {
        RenderView { context, size in
            try RenderPass {
                try RenderPipeline(
                    vertexShader: library.colorfulTriangleVertexShader,
                    fragmentShader: library.colorfulTriangleFragmentShader
                ) {
                    Draw { encoder in
                        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
