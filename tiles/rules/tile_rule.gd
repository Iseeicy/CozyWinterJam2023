extends Resource
class_name TileRule

#
#   Constants
#

const LAYER_BACKGROUND: int = 0
const LAYER_GROUND: int = 1
const LAYER_FOREGROUND: int = 2

const ID_ICE: int = 0
const ID_SNOW: int = 2
const ID_WALL: int = 3
const ID_SPIKES: int = 4
const ID_PIT: int = 5
const ID_CRACK: int = 6
const ID_ELECTRIC_WALL: int = 7
const ID_ICICLE: int = 8
const ID_PRESENT: int = 9

#
#   Private Variables
#

var _handling_dict: Dictionary = {}

#
#   Virtual Methods
#

## The ID of the source tile that this rule is for.
func get_tile_id() -> int:
    return -1

func hit_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, _body: RigidBody2D, _player: BallsPlayer) -> void:
    return

func enter_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, _body: RigidBody2D, _player: BallsPlayer) -> void:
    return

func exit_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, _body: RigidBody2D, _player: BallsPlayer) -> void:
    return

func grapple_locked_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, _grapple: Grapple3, _point: Vector2, _normal: Vector2, _player: BallsPlayer) -> void:
    return

func grapple_unlocked_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, _grapple: Grapple3, _point: Vector2, _normal: Vector2, _player: BallsPlayer) -> void:
    return

func reset() -> void:
    return

#
#   Functions
#

func play_oneshot_at_tile(tile_map: TileMap, position: Vector2i, audio_stream: AudioStream) -> OneshotAudioStreamPlayer2D:
    if not audio_stream: return null
    var world_pos = tile_map.to_global(tile_map.map_to_local(position))
    
    return OneshotAudioStreamPlayer2D.quick_play_oneshot(
        tile_map.get_parent(), 
        audio_stream, 
        world_pos
    )

func set_is_handling(tile_position: Vector2i, is_handling: bool) -> void:
    _handling_dict[tile_position] = is_handling

func get_is_handling(tile_position: Vector2i) -> bool:
    return _handling_dict.get(tile_position, false)