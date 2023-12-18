extends Node

@export var main_level_scene: PackedScene = null

func _ready():
	CheckpointManager.spawn_player_on_start = false
	$SplashScreen.show()
	$MainMenu.hide()

	$SplashScreen.run()
	# $MainMenu.show()

func _on_splash_screen_completed():
	$MainMenu.show()


func _on_main_menu_start_game():
	$SplashScreen.hide()
	$MainMenu.hide()
	var level = main_level_scene.instantiate()
	add_child(level)

	CheckpointManager.respawn()
