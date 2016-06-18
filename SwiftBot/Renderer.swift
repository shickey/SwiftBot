import simd

var renderingLevel : Level! = levels[0]

var mapVertexData : [Float] = []

public func updateAndRender(dt: Double, renderMemory: UnsafeMutablePointer<Void>) -> Int {
    
    if mapVertexData.count == 0 {
        buildMapVertices(renderingLevel.map)
    }
    
    memcpy(renderMemory, mapVertexData, mapVertexData.count * sizeof(Float))
    
    return mapVertexData.count
    
//    renderMemory.assignFrom(data, count: data.count)
}

func buildMapVertices(map: Map) {
    
    let scale : Float = 2.0 / Float(map.size.width)
    var levelTransform : float4x4 = float4x4(1)
    levelTransform[0][0] = scale
    levelTransform[1][1] = -scale
    
    // Invert y and move map into position
    levelTransform[3][0] = -1.0
    levelTransform[3][1] = 1.0


    for y in 0..<map.size.height {
        for x in 0..<map.size.width {

            let originX = Float(x);
            let originY = Float(y);

            var color : float4 = float4(1.0, 1.0, 1.0, 1.0)
            if map.tileAtLocation(Point(x, y)) == .Wall {
                color = float4(0.0, 0.0, 1.0, 1.0)
            }

            let v0 = levelTransform * float4(originX,       originY,       0.0, 1.0)
            let v1 = levelTransform * float4(originX + 1.0, originY,       0.0, 1.0)
            let v2 = levelTransform * float4(originX + 1.0, originY + 1.0, 0.0, 1.0)
            let v3 = levelTransform * float4(originX,       originY + 1.0, 0.0, 1.0)

            let quad = Quad(v0, v1, v2, v3, color)

            mapVertexData += quad.data
        }
    }
}