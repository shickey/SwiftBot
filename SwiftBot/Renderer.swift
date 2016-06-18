import simd

var renderingLevel : Level! = levels[0]

var mapNeedsRender = true
var mapVertexData : [Float] = []

var worldTransform : float4x4 = float4x4(1)

public func updateAndRender(dt: Double, renderMemory: UnsafeMutablePointer<Void>) -> Int {
    
    if mapNeedsRender {
        worldTransform = computeWorldTransform(renderingLevel)
        mapVertexData = renderMap(renderingLevel.map)
    }
    
    let robotVerts = renderRobot(renderingLevel)
    
    memcpy(renderMemory, mapVertexData + robotVerts, (mapVertexData.count + robotVerts.count) * sizeof(Float))
    
    return (mapVertexData.count + robotVerts.count)
}

func computeWorldTransform(level: Level) -> float4x4 {
    let scale : Float = 2.0 / Float(level.map.size.width)
    var transform : float4x4 = float4x4(1)
    transform[0][0] = scale
    transform[1][1] = -scale
    
    // Invert y and move map into position
    transform[3][0] = -1.0
    transform[3][1] = 1.0
    
    return transform
}

func renderMap(map: Map) -> [Float] {
    var mapVerts : [Float] = []
    for y in 0..<map.size.height {
        for x in 0..<map.size.width {

            let originX = Float(x);
            let originY = Float(y);

            var color : float4 = float4(1.0, 1.0, 1.0, 1.0)
            if tileAtMapLocation(map, Point(x, y)) == .Wall {
                color = float4(0.0, 0.0, 1.0, 1.0)
            }

            let v0 = worldTransform * float4(originX,       originY,       0.0, 1.0)
            let v1 = worldTransform * float4(originX + 1.0, originY,       0.0, 1.0)
            let v2 = worldTransform * float4(originX + 1.0, originY + 1.0, 0.0, 1.0)
            let v3 = worldTransform * float4(originX,       originY + 1.0, 0.0, 1.0)

            let quad = Quad(v0, v1, v2, v3, color)

            mapVerts += quad.data
        }
    }
    return mapVerts
}

func renderRobot(level: Level) -> [Float] {
    var robotTransform : float4x4 = float4x4(1)
    
    let facing = level.robot.facing
    var angle : Double = 0.0
    switch facing {
    case .North: break
    case .South:
        angle = M_PI
    case .East:
        angle = M_PI / 2.0
    case .West:
        angle = 3.0 * M_PI / 2.0
    }
    
    // TODO: Fix this cos() ridiculousness. WHY CAN'T I CALL THE VERSION THAT TAKES A DOUBLE??!
    robotTransform[0][0] =  cos(Float(angle))
    robotTransform[0][1] = -sin(Float(angle))
    robotTransform[1][0] =  sin(Float(angle))
    robotTransform[1][1] =  cos(Float(angle))
    
    let location = level.robot.location
    robotTransform[3][0] = Float(location.x) + 0
    robotTransform[3][1] = Float(location.y)
    
    robotTransform = worldTransform * robotTransform
    
    let color = float4(1.0, 0.75, 0.5, 1.0)
    
    let bodyV0 = robotTransform * float4(0.0, 1.0, 0.0, 1.0)
    let bodyV1 = robotTransform * float4(0.0, 0.5, 0.0, 1.0)
    let bodyV2 = robotTransform * float4(1.0, 0.5, 0.0, 1.0)
    let bodyV3 = robotTransform * float4(1.0, 1.0, 0.0, 1.0)
    let bodyQuad = Quad(bodyV0, bodyV1, bodyV2, bodyV3, color)
    
    let noseV0 = robotTransform * float4(0.5, 0.0, 0.0, 1.0)
    let noseV1 = robotTransform * float4(1.0, 0.5, 0.0, 1.0)
    let noseV2 = robotTransform * float4(0.0, 0.5, 0.0, 1.0)
    let noseTri = Triangle(noseV0, noseV1, noseV2, color)
    
    return bodyQuad.data + noseTri.data
    
}
