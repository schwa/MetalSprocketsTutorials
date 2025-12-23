import MetalSprockets
import MetalSprocketsUI
import SwiftUI
import simd

struct ContentView: View {
    var body: some View {
        RenderView { context, size in
            // Get elapsed time for animation
            let time = context.frameUniforms.time

            // Model matrix: rotation based on time (spinning cube)
            let modelMatrix = cubeRotationMatrix(time: TimeInterval(time))

            // View matrix: camera positioned back along Z axis
            let viewMatrix = float4x4.translation(0, 0, -6)

            // Projection matrix: perspective with 45° FOV
            let aspect = size.height > 0 ? Float(size.width / size.height) : 1.0
            let projectionMatrix = float4x4.perspective(
                fovY: .pi / 4,  // 45 degrees
                aspect: aspect,
                near: 0.1,
                far: 100.0
            )

            let uniforms = Uniforms(
                modelMatrix: modelMatrix,
                viewMatrix: viewMatrix,
                projectionMatrix: projectionMatrix
            )

            try RenderPass {
                try SpinningCubeRenderPipeline(uniforms: uniforms)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        // Required for depth testing - without this, back faces render over front faces
        .metalDepthStencilPixelFormat(.depth32Float)
    }
}
