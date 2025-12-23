#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

// Uniforms containing our 3 matrices
struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut cubeVertexShader(VertexIn in [[stage_in]],
                                   constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut out;

    // Transform vertex through model -> view -> projection
    float4 worldPosition = uniforms.modelMatrix * float4(in.position, 1.0);
    float4 viewPosition = uniforms.viewMatrix * worldPosition;
    out.position = uniforms.projectionMatrix * viewPosition;

    out.color = in.color;
    return out;
}

fragment float4 cubeFragmentShader(VertexOut in [[stage_in]]) {
    return in.color;
}
