extends "res://scenes/main.gd"

func new_game():
	score = 0
	#level = 1
	$Player.start($PlayerSpawnPoint.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_level(level)
	$HUD.update_health($Player.health)
	$HUD.show_message('Get ready!')
	#$Music.play()
	$Boss.start($Player)
