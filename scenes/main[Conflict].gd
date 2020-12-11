extends Node2D

export var velocity = Vector2()
export var level = 1
var score
var screen_width

func _ready():
	$HUD.connect("start_game", self, "new_game")
	$StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	$Player.connect("player_hit", self, "check_game_over")
	$EnemyController.connect("enemy_destroyed", self, "_on_Enemy_destroyed")
	
	randomize()
	screen_width = get_viewport().size.x
	#$HUD/MainMenu.hide()
	

func _process(delta):
	#translate(velocity * delta)
	pass

# Links player hit to game over condition
func check_game_over(health):
	if(health <= 0):
		#$ScoreTimer.stop()
		#$MobTimer.stop()
		$HUD.show_game_over()
		$Music.stop()
		$EnemyController.stop_spawning()
		#$GameOverSound.play()

func new_game():
	score = 0
	#level = 1
	$Player.start($PlayerSpawnPoint.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_level(level)
	$HUD.update_health($Player.health)
	$HUD.show_message('Get ready!')
	$Music.play()
	

#func _on_HUD_start_game():
#	$Player.show()
#	$EnemyController._spawn_enemies(level)
#	pass # Replace with function body.
	
func _on_StartTimer_timeout():
	$EnemyController._spawn_enemies(level)
	
func _on_Enemy_destroyed():
	score += 1
	$HUD.update_score(score)
	$EnemyController.Enemy_destroyed()
	
# This is from https://docs.godotengine.org/en/latest/tutorials/inputs/inputevent.html?highlight=get_tree%20quit
# It doesn't use the InputMap and could definitely be coded more cleanly
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()


func _on_Player_special_avilable():
	print("Player has new special")
	$HUD/MainMenu/ChargingIndicator.connect("charged", $Player/RainbowBeam, "_on_charged")
	$Player/RainbowBeam.connect("charging", $HUD/MainMenu/ChargingIndicator, "_on_RainbowBeam_charging")
	$Player/RainbowBeam.connect("charging", $HUD, "_on_RainbowBeam_charging")
