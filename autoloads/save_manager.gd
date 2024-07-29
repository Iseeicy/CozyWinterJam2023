extends Node

#
# Variables
#

## This is where the save file is stored
var save_file_path = "user://save_game.tres"

## These store the current checkpoint and collected presents of the player
var current_checkpoint: Checkpoint = null
var current_saved_collection: Dictionary = {}

## This is what is used to spawn the player at a specific position when loading
var load_position: Vector2

## These bools handle the save text fading up and down and also whether or not 
## we're ready for saving
var ready_to_save: bool = false
var show_saved_text = false
var get_rid_of_saved_text = false

## This is when we start fading up or down
var start_time: float = -1

## This is the time it takes for the save text to fade up and a third of the
## time it takes for it to fade down
var time_text_fade = 1500

## This is a reference to the actual text to display
var saved_text: Label

func _ready():
	# Connect up the signals needed
	CheckpointManager.checkpoint_flagged.connect(on_checkpoint_flagged.bind())
	PresentManager.collected_updated.connect(on_collection_saved.bind())
	get_node("/root/GameEntry").level_loaded.connect(on_scene_ready_for_load.bind())

func _process(delta):
	# Set start time to an actual value to use for math
	if start_time == -1:
		start_time = Time.get_ticks_msec()
	
	if saved_text != null:
		if show_saved_text:
			# Fade text up
			saved_text.add_theme_color_override("font_color", lerp(Color(1, 1, 1, 0), Color(1, 1, 1, 1)\
			, (Time.get_ticks_msec() - start_time) / time_text_fade))

			if Time.get_ticks_msec() - start_time >= time_text_fade:
				# Set up the fade down and stop us from fading up again
				start_time = -1
				show_saved_text = false
				get_rid_of_saved_text = true
				saved_text.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		elif get_rid_of_saved_text:
			# Make the fade back 3 times longer to let the user have a chance to read it
			# Fade text down
			saved_text.add_theme_color_override("font_color", lerp(Color(1, 1, 1, 1), Color(1, 1, 1, 0)\
			, (Time.get_ticks_msec() - start_time) / time_text_fade / 3))

			if Time.get_ticks_msec() - start_time >= time_text_fade * 3:
				# Make sure we don't fade down again
				get_rid_of_saved_text = false
				saved_text.add_theme_color_override("font_color", Color(1, 1, 1, 0))

func save_game():
	# If we have a checkpoint to save to
	if current_checkpoint == null:
		return
	
	var save_game : SaveFile
	
	if save_file_exists():
		save_game = ResourceLoader.load(save_file_path)
	else:
		save_game = SaveFile.new()
	
	# Store all the data
	save_game.checkpoint_pos = current_checkpoint.global_position
	save_game.collected_presents = current_saved_collection
	
	var err = ResourceSaver.save(save_game, save_file_path)
	
	if (err != OK):
		printerr("ERROR: Something went wrong when saving! Error Code: " + str(err))
		return

	# Set up parameters needed for save text
	start_time = -1
	show_saved_text = true

func load_game():
	if not save_file_exists():
		printerr("ERROR: Save File not Found!")
		return
	
	var save_game : SaveFile = ResourceLoader.load(save_file_path)
	
	# Load all the data
	load_position = save_game.checkpoint_pos
	current_saved_collection = save_game.collected_presents

# Check if the file exists and if it isn't empty
func save_file_exists() -> bool:
	return ResourceLoader.exists(save_file_path)

func on_checkpoint_flagged(checkpoint: Checkpoint):
	# Set the current checkpoint
	current_checkpoint = checkpoint
	
	# If we re ready to save and have presents to save then we should save
	if len(current_saved_collection) > 0 and ready_to_save:
		save_game()
		ready_to_save = false

func on_collection_saved(held: Dictionary, saved: Dictionary):
	# If we actually collected presents then get us ready to save
	if len(held) > 0:
		ready_to_save = true
	elif ready_to_save and saved == current_saved_collection:
		ready_to_save = false
	
	# Set the current collection of saved presents
	current_saved_collection = saved

func on_scene_ready_for_load():
	# Set the saved text reference
	saved_text = get_node("/root/GameEntry/Saved Text/Text")
	
	# If we actually loaded any data
	if load_position == Vector2.ZERO:
		return
	
	# Set the currently collected presents
	for type in current_saved_collection.keys():
		var arr = PresentManager._saved_collection.get(type, [])
		arr.append_array(current_saved_collection[type])
		PresentManager._saved_collection[type] = arr
	
	# Tell people that the collection was updated
	PresentManager.collected_updated.emit(PresentManager.get_held_collected(), \
	PresentManager.get_saved_collected())
	
	# Make all the presents we just set as collected stop existing
	for type in current_saved_collection.keys():
		for present in current_saved_collection[type]:
			get_node("/root/GameEntry/MainLevel/TileMap").set_cell(3, present, -1)
	
	# Respawn the player at the position we want to load them at
	CheckpointManager.respawn(load_position)
