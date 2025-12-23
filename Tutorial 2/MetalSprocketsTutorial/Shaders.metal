#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
    float2 textureCoordinate [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinate;
};

vertex VertexOut rainbowQuadVertexShader(VertexIn in [[stage_in]]) {
    VertexOut out;
    out.position = float4(in.position, 0.0, 1.0);
    out.textureCoordinate = in.textureCoordinate;
    return out;
}

float3 hueToRGB(float hue) {
    float3 rgb = abs(fmod(hue * 6.0 + float3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0;
    return saturate(rgb);
}

fragment float4 rainbowQuadFragmentShader(VertexOut in [[stage_in]]) {
    float hue = (in.textureCoordinate.x + in.textureCoordinate.y) * 0.5;
    float3 color = hueToRGB(hue);
    return float4(color, 1.0);
}
