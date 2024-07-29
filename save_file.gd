extends Resource

class_name SaveFile

## This specifies of the position of the checkpoint to spawn the player at
@export var checkpoint_pos : Vector2

## This specifies all the presents that the player has collected the key
## is the type of present with the value being a array of all the positions 
## (stored as Vector2i) of where presents of that type would be in the tilemap
@export var collected_presents : Dictionary

func _init(position : Vector2 = Vector2.ZERO, collected : Dictionary = {}):
	checkpoint_pos = position
	collected_presents = collected
