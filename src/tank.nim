import godot, kinematic_body_2d, timer

gdobj Tank of KinematicBody2D:
    var
        bullet* {.gdExport.}: PackedScene
        maxSpeed* {.gdExport.}: float
        rotationSpeed* {.gdExport.}: float
        gunCooldown* {.gdExport.}: float
        maxHealth {.gdExport.}: int
        health: int

        gunTimer*: Timer        
        velocity* = vec2()
        canShoot* = true
        alive* = true


    method init*() =
        addUserSignal("health_changed")
        addUserSignal("dead")
        addUserSignal("shoot")

    method shoot*() {.base.} =
        if canShoot:
            canShoot = false
            gunTimer = getNode("GunTimer").as(Timer)
            gunTimer.start()
            var
                turret = getNode("Turret") as Sprite 
                muzzle = getNode("Turret/Muzzle") as Position2D
                dir = vec2(1.0, 0.0).rotated(turret.globalRotation)
            print("emits shoot now")
            emitSignal("shoot", 
                       bullet.toVariant,
                       muzzle.globalPosition.toVariant,
                       dir.toVariant
                       )

    
    proc explode() = 
        queueFree()

    method takeDamage*(amount: int) {.base.} =
        health -= amount
        emitSignal("health_changed", (health * 100/maxHealth).toVariant)
        if health <= 0:
            explode()
    
    method ready*() =
        health = maxHealth
        emitSignal("health_changed", (health * 100/maxHealth).toVariant)
        gunTimer = getNode("GunTimer") as Timer
        gunTimer.waitTime = gunCooldown

    method control*(delta: float64) {.base.} = discard
    
    method physicsProcess*(delta: float64) =
        if not alive: discard
        control(delta)
        discard moveAndSlide(velocity)

    proc onGunTimerTimeout*() {.gdExport.} =
        canShoot = true