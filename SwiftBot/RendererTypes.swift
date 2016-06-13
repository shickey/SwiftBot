import simd

extension float4 {
    var r : Float { return x }
    var g : Float { return y }
    var b : Float { return z }
    var a : Float { return w }
}

struct Vertex {
    
    var position : float4 = float4(0.0, 0.0, 0.0, 1.0)
    var color : float4 = float4(0.0, 0.0, 0.0, 1.0)
    
    init(_ newPosition : float4) {
        position = newPosition
    }
    
    init(_ newPosition : float4, _ newColor : float4) {
        position = newPosition
        color = newColor
    }
    
    var data : [Float] {
        return [position.x, position.y, position.z, position.w, color.r, color.g, color.b, color.a]
    }
    
}

struct Triangle {
    
    let v0 : Vertex
    let v1 : Vertex
    let v2 : Vertex
    
    init(_ newV0: Vertex, _ newV1: Vertex, _ newV2: Vertex) {
        v0 = newV0
        v1 = newV1
        v2 = newV2
    }
    
    init(_ v0Pos : float4, _ v1Pos : float4, _ v2Pos : float4, _ color : float4) {
        v0 = Vertex(v0Pos, color)
        v1 = Vertex(v1Pos, color)
        v2 = Vertex(v2Pos, color)
    }
    
    var vertices : [Vertex] {
        return [v0, v1, v2]
    }
    
    var data : [Float] {
        return v0.data + v1.data + v2.data
    }
    
}

struct Quad {
    
    let v0 : Vertex
    let v1 : Vertex
    let v2 : Vertex
    let v3 : Vertex
    
    // Specify in clockwise order
    init(_ newV0: Vertex, _ newV1: Vertex, _ newV2: Vertex, _ newV3: Vertex) {
        v0 = newV0
        v1 = newV1
        v2 = newV2
        v3 = newV3
    }
    
    init(_ v0Pos : float4, _ v1Pos : float4, _ v2Pos : float4, _ v3Pos : float4, _ color : float4) {
        v0 = Vertex(v0Pos, color)
        v1 = Vertex(v1Pos, color)
        v2 = Vertex(v2Pos, color)
        v3 = Vertex(v3Pos, color)
    }
    
    var vertices : [Vertex] {
        return [v0, v1, v2, v3]
    }
    
    var triangles : [Triangle] {
        return [Triangle(v0, v1, v2), Triangle(v2, v3, v0)]
    }
    
    var data : [Float] {
        return triangles[0].data + triangles[1].data
    }
    
}