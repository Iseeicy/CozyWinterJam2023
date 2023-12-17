extends TileRule
class_name PitRule

#
#   Exports
#

## The sound to play when the player starts falling down the pit
@export var fall_start_sound: AudioStream = null

## The sound to play when the player has fallen all the way down the pit
@export var fall_complete_sound: AudioStream = null

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_PIT

func enter_tile(tile_map: TileMap, position: Vector2i, body: PhysicsBody2D, player: BallsPlayer) -> void:
    if get_is_handling(position): return
    set_is_handling(position, true)
    
    play_oneshot_at_tile(tile_map, position, fall_start_sound)
    body.set_physics_process(false)
    await tile_map.get_tree().create_timer(0.5).timeout
    
    play_oneshot_at_tile(tile_map, position, fall_complete_sound)
    tile_map.set_cell(
        TileRule.LAYER_GROUND, 
        position, 
        TileRule.ID_PIT, 
        tile_map.get_cell_atlas_coords(TileRule.LAYER_GROUND, position),
        tile_map.get_cell_alternative_tile(TileRule.LAYER_GROUND, position)
    )

    player.kill(body, BallsPlayer.KillType.Fall)
    set_is_handling(position, false)