import godot, tank, sprite, input, timer, player_bullet, resource_loader

gdobj Player of Tank:
    var
        turret: Sprite

    method control*(delta: float64) =
        turret = getNode("Turret") as Sprite
        turret.lookAt(getGlobalMousePosition())
        var rotationDir: float64 = 0
        if isActionPressed("ui_right"): rotationDir += 1
        elif isActionPressed("ui_left"): rotationDir -= 1
        
        self.rotation = self.rotation + rotationSpeed * rotationDir * delta
        velocity = vec2()
        
        if isActionPressed("ui_up"):
            velocity = vec2(maxSpeed, 0.0).rotated(self.rotation)
        elif isActionPressed("ui_down"):
            velocity = vec2(-maxSpeed/2,0.0).rotated(self.rotation)
        if isActionJustPressed("shoot"): shoot()
