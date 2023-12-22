extends SplashScreen


func run_splash_sequence():
	$Logo.hide()
	$SplashSound.play()
	await get_tree().create_timer(0.10).timeout

	$Logo.scale = Vector2(0.2, 0.2)
	$Logo.show()
	await get_tree().create_timer(0.50).timeout

	$Logo.scale = Vector2(0.3, 0.3)
	await get_tree().create_timer(0.50).timeout

	$Logo.scale = Vector2(0.4, 0.4)
	await get_tree().create_timer(0.50).timeout

	$Logo.scale = Vector2(1.0, 1.0)
	await get_tree().create_timer(3.0).timeout

	finished.emit()