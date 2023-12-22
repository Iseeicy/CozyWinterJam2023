extends SplashScreen


func _run_splash_sequence():
	$AnimationPlayer.play("trash_splash")
	return
	# $LogoLight.hide()
	# $LogoDark.hide()
	
	# $SplashSound.play()
	# $LogoDark.show()
	# await get_tree().create_timer(1.38).timeout

	# $LogoLight.show()

	# await get_tree().create_timer(3.0).timeout
	# finished.emit()


func _on_animation_player_animation_finished(anim_name):
	finished.emit()
