import godot, tank, node, path_follow_2d, sprite
import collision_shape_2d, circle_shape_2d, ray_cast_2d
import lerp

gdobj Enemy of Tank:
    var 
        turretSpeed* {.gdExport.} = 1.0
        detectRadius* {.gdExport.} = 400
        target: Node2D
        lookAhead1: RayCast2D
        lookAhead2: RayCast2D
        speed*: float

    method control*(delta: float64) =       
        if lookAhead1.isColliding() or lookAhead2.isColliding():
            speed = speed.lerp(0.0, 0.05)
        else:
            speed = speed.lerp(maxSpeed, 0.05)
        var parent = getParent() as PathFollow2D
        if parent != nil:
            parent.offset = parent.offset + speed * delta
            self.position = vec2()
        else: discard
    
    method ready*() =
        var
            detectColl = getNode("DetectRadius/CollisionShape2D") as CollisionShape2D
            circle = gdnew[CircleShape2D]()
            
        circle.radius = detectRadius
        detectColl.shape = circle
        lookAhead1 = getNode("LookAhead1") as RayCast2D
        lookAhead2 = getNode("LookAhead2") as RayCast2D
        var unitDisplay = getNode("UnitDisplay") as Node2D
        discard self.connect("health_changed", unitDisplay, "update_health_bar", newArray()) 
    
    method process*(delta: float64) =
        if target != nil:
            var
                turret = getNode("Turret") as Sprite
                targetDir = (target.globalPosition - self.globalPosition).normalized()
                currentDir = vec2(1.0,0.0).rotated(turret.globalRotation)
            turret.globalRotation = currentDir.lerp(targetDir,
                                                   turretSpeed * delta
                                                   ).angle()
            if targetDir.dot(currentDir) > 0.9:
                shoot()

    #signal procs so enemy can find the player 
    proc onRadiusBodyEntered*(body: Tank) {.gdExport.} =
            self.target = body
    
    proc onRadiusBodyExited*(body: Tank) {.gdExport.} =
        if body == target: 
            self.target = nil
