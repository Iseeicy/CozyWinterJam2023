extends TileRule
class_name SpikeRule

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_SPIKES

func hit_tile(_tile_map: TileMap, position: Vector2i, body: PhysicsBody2D, player: BallsPlayer) -> void:
    if get_is_handling(position): return
    set_is_handling(position, true)
    
    player.kill(body, BallsPlayer.KillType.Shatter)
    set_is_handling(position, false)