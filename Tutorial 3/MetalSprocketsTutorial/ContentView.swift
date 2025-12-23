import MetalSprockets
import MetalSprocketsUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        RenderView { context, size in
            try RenderPass {
                try RainbowQuadRenderPipeline(time: context.frameUniforms.time)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
