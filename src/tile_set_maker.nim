import godot, node, sprite, texture, tile_set
import resource_saver

gdobj TileSetMaker of Node:
    var 
        tileSize = vec2(128, 128)
    
    method ready*() =
        var 
            texture = getNode("Sprite").as(Sprite).texture
            tex_width = texture.getWidth().float / tile_size.x
            tex_height = texture.getHeight().float / tile_size.y
            ts = gdnew[TileSet]()     
        
        for x in 0..tex_width.int-1:
            for y in 0..tex_height.int-1:
                var 
                    region = initRect2(
                                    x.float * tileSize.x, 
                                    y.float * tileSize.y,
                                    tileSize.x, tileSize.y)
                    id = x + y * 10
                ts.createTile(id)
                ts.tileSetTexture(id, texture)
                ts.tileSetRegion(id, region)
        
        discard save("res://assets/terrain_tiles.tres", ts)
        

            
    