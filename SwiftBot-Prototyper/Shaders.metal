#import <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[ position ]];
    float4 color;
};

vertex Vertex tile_vertex_shader(device Vertex *vertices [[ buffer(0) ]],
                                 unsigned int vid [[ vertex_id ]]) {
    return vertices[vid];
}

fragment half4 tile_fragment_shader(Vertex v [[ stage_in ]]) {
    return half4(v.color);
}