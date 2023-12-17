extends TileRule
class_name CrackRule

#
#   Exports
#

## When the player touches a crack, after this many seconds, the crack will become a pit.
@export var time_until_crumble: float = 0.5

## The sound to play when crumbling begins
@export var crumble_start_sound: AudioStream = null

## The sound to play when crumbling has completed
@export var crumble_complete_sound: AudioStream = null

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_CRACK

func enter_tile(tile_map: TileMap, position: Vector2i, _body: PhysicsBody2D, _player: BallsPlayer) -> void:
    if get_is_handling(position): return
    set_is_handling(position, true)
    
    play_oneshot_at_tile(tile_map, position, crumble_start_sound)
    await tile_map.get_tree().create_timer(0.5).timeout
    
    play_oneshot_at_tile(tile_map, position, crumble_complete_sound)
    tile_map.set_cell(
        TileRule.LAYER_GROUND, 
        position, 
        TileRule.ID_PIT, 
        tile_map.get_cell_atlas_coords(TileRule.LAYER_GROUND, position),
        tile_map.get_cell_alternative_tile(TileRule.LAYER_GROUND, position)
    )

    set_is_handling(position, false)