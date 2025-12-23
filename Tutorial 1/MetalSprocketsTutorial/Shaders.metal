#include <metal_stdlib>
using namespace metal;

// Output from vertex shader, input to fragment shader
struct VertexOut {
    float4 position [[position]];  // Required: clip-space position
    float4 color;                  // Interpolated across the triangle
};

vertex VertexOut colorfulTriangleVertexShader(uint vertexID [[vertex_id]]) {
    const float2 positions[] = {
        float2(0.0, 0.75),
        float2(-0.75, -0.75),
        float2(0.75, -0.75)
    };

    const float4 colors[] = {
        float4(1.0, 0.0, 0.0, 1.0),
        float4(0.0, 1.0, 0.0, 1.0),
        float4(0.0, 0.0, 1.0, 1.0)
    };

    VertexOut out;
    out.position = float4(positions[vertexID], 0.0, 1.0);
    out.color = colors[vertexID];
    return out;
}

fragment float4 colorfulTriangleFragmentShader(VertexOut in [[stage_in]]) {
    return in.color;
}
