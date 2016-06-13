#import <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[ position ]];
    float4 color;
};

vertex Vertex tile_vertex_shader(device Vertex *vertices [[ buffer(0) ]],
                                 device float4x4 &transform [[ buffer(1) ]],
                                 unsigned int vid [[ vertex_id ]]) {
    Vertex v = vertices[vid];
    v.position = transform * v.position;
    return v;
}

fragment half4 tile_fragment_shader(Vertex v [[ stage_in ]]) {
    return half4(v.color);
}