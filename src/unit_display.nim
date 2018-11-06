import godot, node_2d, resource_loader, texture_progress

gdobj UnitDisplay of Node2D:
    var
        
        barRed = load("res://assets/UI/barHorizontal_red_mid 200.png") as Texture
        barGreen = load("res://assets/UI/barHorizontal_green_mid 200.png") as Texture
        barYellow = load("res://assets/UI/barHorizontal_yellow_mid 200.png") as Texture
    
    method ready*() =
        for n in getChildren():
            asObject[CanvasItem](n).hide()
        
    proc updateHealthBar*(value: float) {.gdExport.} = 
        var healthBar = getNode("HealthBar") as TextureProgress
        healthBar.textureProgress = barGreen
        if value < 60:
            healthBar.textureProgress = barYellow
        if value < 25:
            healthBar.textureProgress = barRed
        if value < 100:
            healthBar.show()
        healthBar.value = value
    
    method process*(delta: float64) =
        self.globalRotation = 0.0
            