extends Node

@export var main_level_scene: PackedScene = null
var _level: Node2D = null

func _ready():
	PauseMenu.set_can_pause(false)
	CheckpointManager.spawn_player_on_start = false
	$SplashScreen.show()
	$MainMenu.hide()
	$IntroCutscene.hide()

	$SplashScreen.run()
	# $MainMenu.show()

func _on_splash_screen_completed():
	$MainMenu.show()


func _on_main_menu_start_game():
	$SplashScreen.hide()
	$MainMenu.hide()
	
	$IntroCutscene.show()
	$IntroCutscene.run()
	

func _on_intro_cutscene_cutscene_complete():
	$IntroCutscene.hide()
	await get_tree().create_timer(2.0).timeout
	$Controls.show()
	

func _deffered_load_level(level):
	await get_tree().create_timer(2.0).timeout
	
	_level = level
	_level.level_completed.connect(_on_level_complete.bind())
	
	add_child(level)
	PauseMenu.set_can_pause(true)
	CheckpointManager.respawn()
	
func _on_level_complete():
	CheckpointManager.despawn()
	PauseMenu.set_can_pause(false)
	_level.queue_free()
	_level = null
	
	await get_tree().create_timer(2.0).timeout
	
	$OutroCutscene.show()
	$OutroCutscene.run()


func _on_outro_cutscene_cutscene_complete():
	$OutroCutscene.hide()
	await get_tree().create_timer(4.0).timeout
	$Credits.show()


func _on_controls_finished():
	$Controls.hide()
	var level = main_level_scene.instantiate()
	_deffered_load_level.call_deferred(level)
