extends Node2D

################
# VARIABLES
################
export var velocity = Vector2()
export var level = 1
var score
var screen_width

var boss_interval = 3

################
# SIGNALS
################
signal boss_fight
#signal game_start # Start game is emitted by HUD
signal game_over#(level, score)
signal level_up
signal wave_start # Maybe meld into game_start(level)?

func _ready():
	# Connect 
	# Music
	$HUD.connect("start_game", $Music, "_on_game_start")
	self.connect("game_over", $Music, "_on_game_over")
	# HUD
	$HUD.connect("start_game", self, "new_game")
	$HUD.connect("start_game", $EnemyController, "_on_new_game")
	self.connect("game_over", $HUD, "_show_game_over")
	$StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	#$Player.connect("player_hit", self, "check_game_over")
	$Player.connect("has_died", self, "_check_game_over")
	self.connect("game_over", $EnemyController, "_on_game_over")
	$EnemyController.connect("enemy_destroyed", self, "_on_Enemy_destroyed")
	$EnemyController.connect("level_up", $HUD, "_on_EnemyController_level_up")
	$EnemyController.connect("level_up", self, "_on_EnemyController_level_up")
	self.connect("boss_fight", $EnemyController, "_spawn_boss")
	
	randomize()
	screen_width = get_viewport().size.x
	#$HUD/MainMenu.hide()
	

func _process(delta):
	#translate(velocity * delta)
	pass

# Want to redo to emit game over signal
func _check_game_over(lives):
	if lives <= 0:
		emit_signal("game_over")#, level, score)
		#$HUD.show_game_over()
		#$Music.stop()
		#$EnemyController.stop_spawning()

# Links player hit to game over condition
# Old version, trying out new above
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
	#$Music.play()
	

#func _on_HUD_start_game():
#	$Player.show()
#	$EnemyController._spawn_enemies(level)
#	pass # Replace with function body.
	
func _on_StartTimer_timeout():
	#$EnemyController._spawn_enemies(level)
	pass
	
func _on_Enemy_destroyed():
	score += 1
	$HUD.update_score(score)
	$EnemyController.Enemy_destroyed()
	
# When level is finished, the following has to happen
# Enemies stop spawning/are destroyed if the game tries to keep spawning
# HUD displays stats
# Hud displays "Wave [#]"
# Either enemies start spawning again, or boss fight
func _on_EnemyController_level_up(level):

	$EnemyController.stop_spawning()
	# HUD wave_end
	$HUD.show_message("Wave " + str(level) + " completed")
	if level % boss_interval == 0:
		$HUD.show_message("WARNING")
		emit_signal("boss_fight")
		pass
	else:
		# Else start spawning again
		$EnemyController.start_spawning()
		pass
	pass
	
# This is from https://docs.godotengine.org/en/latest/tutorials/inputs/inputevent.html?highlight=get_tree%20quit
# It doesn't use the InputMap and could definitely be coded more cleanly
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
		elif event.pressed and event.scancode == KEY_ENTER:
			$HUD/MainMenu/StartButton.emit_signal("pressed")


func _on_Player_special_avilable():
	print("Player has new special")
	$HUD/MainMenu/ChargingIndicator.connect("charged", $Player/RainbowBeam, "_on_charged")
	$Player/RainbowBeam.connect("charging", $HUD/MainMenu/ChargingIndicator, "_on_RainbowBeam_charging")
	$Player/RainbowBeam.connect("charging", $HUD, "_on_RainbowBeam_charging")
