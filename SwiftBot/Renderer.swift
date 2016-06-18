import simd

var renderingLevel : Level! = levels[0]

var mapNeedsRender = true
var mapVertexData : [Float] = []

var worldTransform : float4x4 = float4x4(1)

let testInstructions = {
    
    for _ in 0..<50 {
        if canGoLeft() {
            turnLeft()
            goForward()
        }
        else if canGoForward() {
            goForward()
        }
        else if canGoRight() {
            turnLeft()
            turnLeft()
            turnLeft()
            goForward()
        }
        else {
            turnLeft()
            turnLeft()
        }
    }
    
}

var instructionsReady = false
var buildingInstructions = false
var executionQueue : ExecutionQueue! = nil
var currentInstruction : ExecutionFrame! = nil

var secondsPerInstruction = 0.1
var instructionTime = 0.0 // Value between 0.0 and 1.0 representing percentage of current instruction time

public func updateAndRender(dt: Double, renderMemory: UnsafeMutablePointer<Void>) -> Int {
    
    var robotRotation = float4x4(1)
    var robotTranslation = float4x4(1)
    
    if !instructionsReady {
        if !buildingInstructions {
            buildExecutionQueueInBackground(renderingLevel, testInstructions, { (queue) in
                executionQueue = queue
                currentInstruction = executionQueue.first
                buildingInstructions = false
                instructionsReady = true
            })
            buildingInstructions = true
        }
    }
    else if currentInstruction != nil {
        // Simulate
        if instructionTime >= 1.0 {
            executeFrameOnLevel(currentInstruction, renderingLevel)
            instructionTime = 0.0
            currentInstruction  = currentInstruction.next
        }
        else {
            instructionTime += dt / secondsPerInstruction
            // Simulate animations
            if currentInstruction.instruction == .TurnLeft {
                robotRotation = rotateTransform((Float(M_PI) / 2.0) * Float(instructionTime))
            }
            else if currentInstruction.instruction == .GoForward {
                switch renderingLevel.robot.facing {
                case .North:
                    robotTranslation = translateTransform(0.0, -1.0 * Float(instructionTime))
                case .South:
                    robotTranslation = translateTransform(0.0, 1.0 * Float(instructionTime))
                case .East:
                    robotTranslation = translateTransform(1.0 * Float(instructionTime), 0.0)
                case .West:
                    robotTranslation = translateTransform(-1.0 * Float(instructionTime), 0.0)
                }
                
            }
        }
    }
    
    if mapNeedsRender {
        worldTransform = computeWorldTransform(renderingLevel)
        mapVertexData = renderMap(renderingLevel.map)
        mapNeedsRender = false
    }
    
    let robotVerts = renderRobot(renderingLevel, robotTranslation, robotRotation)
    
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

func renderRobot(level: Level, _ translation: float4x4, _ rotation: float4x4) -> [Float] {
    var robotTransform : float4x4 = float4x4(1)
    
    let facing = level.robot.facing
    var angle : Double = 0.0
    switch facing {
    case .North: break
    case .South:
        angle = M_PI
    case .East:
        angle = 3.0 * M_PI / 2.0
    case .West:
        angle = M_PI / 2.0
    }
    
    let location = level.robot.location
    
    robotTransform = translateTransform(-0.5, -0.5) * robotTransform
    robotTransform = rotateTransform(Float(angle)) * robotTransform
    robotTransform = rotation * robotTransform
    robotTransform = translateTransform(Float(location.x) + 0.5, Float(location.y) + 0.5) * robotTransform
    robotTransform = translation * robotTransform
    robotTransform = worldTransform * robotTransform
    
    let color = float4(1.0, 0.75, 0.5, 1.0)
    
    let bodyV0 = robotTransform * float4(0.15, 0.85, 0.0, 1.0)
    let bodyV1 = robotTransform * float4(0.15, 0.5, 0.0, 1.0)
    let bodyV2 = robotTransform * float4(0.85, 0.5, 0.0, 1.0)
    let bodyV3 = robotTransform * float4(0.85, 0.85, 0.0, 1.0)
    let bodyQuad = Quad(bodyV0, bodyV1, bodyV2, bodyV3, color)
    
    let noseV0 = robotTransform * float4(0.5, 0.15, 0.0, 1.0)
    let noseV1 = robotTransform * float4(0.85, 0.5, 0.0, 1.0)
    let noseV2 = robotTransform * float4(0.15, 0.5, 0.0, 1.0)
    let noseTri = Triangle(noseV0, noseV1, noseV2, color)
    
    return bodyQuad.data + noseTri.data
    
}

func translateTransform(x: Float, _ y: Float) -> float4x4 {
    var transform = float4x4(1)
    transform[3][0] = x
    transform[3][1] = y
    return transform
}

// TODO: Fix this cos() ridiculousness. WHY CAN'T I CALL THE VERSION THAT TAKES A DOUBLE??!
func rotateTransform(theta: Float) -> float4x4 {
    var transform = float4x4(1)
    transform[0][0] =  cos(theta)
    transform[0][1] = -sin(theta)
    transform[1][0] =  sin(theta)
    transform[1][1] =  cos(theta)
    return transform
}
