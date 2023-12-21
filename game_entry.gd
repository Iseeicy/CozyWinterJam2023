extends Node

@export var main_level_scene: PackedScene = null

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
	var level = main_level_scene.instantiate()
	_deffered_load_level.call_deferred(level)
		

func _deffered_load_level(level):
	add_child(level)
	PauseMenu.set_can_pause(true)
	CheckpointManager.respawn()
	
