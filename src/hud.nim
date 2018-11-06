import godot, canvas_layer, texture_progress, resource_loader, tween
import animation_player

gdobj Hud of CanvasLayer:
    var 
        barRed = load("res://assets/UI/barHorizontal_red_mid 200.png") as Texture
        barGreen = load("res://assets/UI/barHorizontal_green_mid 200.png") as Texture
        barYellow = load("res://assets/UI/barHorizontal_yellow_mid 200.png") as Texture
        barTexture: Texture
        healthBar: TextureProgress

    proc updateHealthBar*(value: float) {.gdExport.} =
        barTexture = barGreen
        if value < 60:
            barTexture = barYellow
        if value < 25:
            barTexture = barRed
        healthBar = getNode("Margin/Container/HealthBar") as TextureProgress
        var tween = getNode("Margin/Container/HealthBar/Tween") as Tween
        healthBar.textureProgress = barTexture
        discard tween.interpolateProperty(healthBar,
                                          "value",
                                          healthBar.value.toVariant,
                                          value.toVariant,
                                          0.2,
                                          TRANS_LINEAR,
                                          EASE_IN_OUT)
        discard tween.start()
        var animPlay = getNode("HealthBarFlash") as AnimationPlayer
        animPlay.play("healthbar_flash")
    
    proc onAnimationFinished*(animName: string) {.gdExport.} =
        if animName == "healthbar_flash":
            healthBar = getNode("Margin/Container/HealthBar") as TextureProgress
            healthBar.textureProgress = barTexture
