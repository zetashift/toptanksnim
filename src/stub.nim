# Copyright 2017 Xored Software, Inc.

## Import independent scene objects here
## (no need to import everything, just independent roots)

when not defined(release):
  import segfaults # converts segfaults into NilAccessError

import tank
import player
import tile_set_maker
import map
import enemy
import bullet
import player_bullet
import hud
import unit_display