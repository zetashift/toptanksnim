import godot, area_2d, timer, tank, animated_sprite

gdobj Bullet of Area2D:
    var
        speed* {.gdExport.}: int = 0
        damage* {.gdExport.}: int = 0
        lifetime* {.gdExport.}: float64 = 0
        velocity = vec2()
        timer: Timer
    
    method ready*() =
        timer = getNode("Lifetime") as Timer
        
    method start*(position: Vector2, direction: Vector2) {.base.} =
        self.position = position
        self.rotation = direction.angle()
        timer.waitTime = lifetime
        timer.start()
        velocity = direction * float64(speed)

    method process*(delta: float64) =
        self.position = self.position + velocity * delta
    
    method explode*() {.base.} =
        velocity = vec2()
        getNode("Sprite").as(Sprite).hide()
        var explosion = getNode("Explosion") as AnimatedSprite
        explosion.show()
        explosion.play("smoke")

    #signal procs
    proc onBulletBodyEntered(body: KinematicBody2D) {.gdExport.} =
        explode()
        body.as(Tank).takeDamage(damage)
        
    
    proc onLifetimeTimeout*() {.gdExport.} = 
        print("bullet lifetime done")
        explode()
        print("done")
    
    proc onExplosionAnimationFinished*() {.gdExport.} =
        queueFree()