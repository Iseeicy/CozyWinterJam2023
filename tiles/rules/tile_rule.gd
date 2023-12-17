extends Resource
class_name TileRule

#
#   Constants
#

const ID_ICE: int = 0
const ID_SNOW: int = 2
const ID_WALL: int = 3
const ID_SPIKES: int = 4
const ID_PIT: int = 5
const ID_CRACK: int = 6
const ID_ELECTRIC_WALL: int = 7

#
#   Virtual Methods
#

## The ID of the source tile that this rule is for.
func get_tile_id() -> int:
    return -1

func enter_tile(_tile_map: TileMap, _position: Vector2i, _body: PhysicsBody2D, _player: BallsPlayer) -> void:
    return