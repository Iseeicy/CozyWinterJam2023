extends TileRule
class_name IcicleRule

#
#   Exports
#

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_ICICLE

func grapple_locked_tile(_tile_map: TileMap, _position: Vector2i, grapple: Grapple3, _point: Vector2, _normal: Vector2, player: BallsPlayer) -> void:
    player.unthrow_grapple(grapple)

func hit_tile(_tile_map: TileMap, position: Vector2i, body: RigidBody2D, player: BallsPlayer) -> void:
    if get_is_handling(position): return
    set_is_handling(position, true)
    
    player.kill(body, BallsPlayer.KillType.Shatter)
    set_is_handling(position, false)