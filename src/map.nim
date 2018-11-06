import godot, node_2d, camera_2d, tile_map, player_bullet, packed_scene, player
import bullet, enemy, hud, input, resource_loader

gdobj Map of Node2D:
    
    proc setCameraLimits*() =
        var mapLimits = getNode("Ground").as(TileMap).getUsedRect()
        var mapCellSize = getNode("Ground").as(TileMap).cellSize
        var playerCam = getNode("Player/Camera2D") as Camera2D
        playerCam.limitLeft = (mapLimits.position.x * mapCellSize.x).int64
        playerCam.limitRight = (mapLimits.size.x * mapCellSize.x).int64
        playerCam.limitTop = (mapLimits.position.y * mapCellSize.y).int64
        playerCam.limitBottom = (mapLimits.size.y * mapCellSize.y).int64 
    
    proc onTankShoot*(bullet: PackedScene,
                      position: Vector2,
                      direction: Vector2) {.gdExport.} =
        
        var b = bullet.instance() as Bullet
        self.addChild(b)
        b.start(position, direction)

    method ready*() =
        setCameraLimits()
        var player = getNode("Player") as Player
        var enemy = getNode("Paths/Path2D/PathFollow2D/Enemy") as Enemy
        discard player.connect("shoot", self, "on_tank_shoot", newArray())
        discard enemy.connect("shoot", self, "on_tank_shoot", newArray())

        var hud = getNode("HUD") as Hud
        discard player.connect("health_changed", hud, "update_health_bar", newArray())
        var cursor = load("res://assets/UI/crossair_black.png") as Texture
        setCustomMouseCursor(cursor, CURSOR_ARROW, vec2(16.0,16.0))