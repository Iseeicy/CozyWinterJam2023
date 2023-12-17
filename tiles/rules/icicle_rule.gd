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