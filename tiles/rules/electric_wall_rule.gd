extends TileRule
class_name ElectricWallRule

#
#   Exports
#

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_ELECTRIC_WALL

func grapple_locked_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, _grapple: Grapple3, _point: Vector2, _normal: Vector2,player: BallsPlayer) -> void:
    player.kill(player.ball_a, BallsPlayer.KillType.Zap)
    player.kill(player.ball_b, BallsPlayer.KillType.Zap)