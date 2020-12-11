extends CanvasLayer

signal start_game
signal open_menu

var default_text = "Rogue + Galaga"
var start_message = Color(1.0, 1.0, 1.0, 1.0)
var end_message = Color(1.0, 1.0, 1.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.show()
	$SettingsMenu.hide()
	$SettingsMenu/CreditsLayer.hide()
	$MainMenu/PowerUpIndicator.hide()

func show_message(text):
	$MainMenu/MessageLabel.text = text
	$MainMenu/MessageLabel.show()
	$MainMenu/MessageTimer.start()

func _show_game_over():
	show_message("Game over")
	yield($MainMenu/MessageTimer, 'timeout')
	$MainMenu/MessageLabel.text = default_text
	$MainMenu/MessageLabel.show()
	yield(get_tree().create_timer(2), 'timeout')
	$MainMenu/StartButton.show()
	$MainMenu/MenuButton.show()
	$MainMenu/ExitGameLabel.show()
	$MainMenu/PowerUpIndicator.hide()
	
func update_score(score):
	$MainMenu/ScoreLabel.text = 'Score: ' + str(score)
	
func update_level(level):
	$MainMenu/LevelLabel.text = 'Level: ' + str(level)
	
func update_health(health):
	$MainMenu/HealthLabel.text = 'Health: ' + str(health)

func _on_MessageTimer_timeout():
	$MainMenu/MessageLabel.hide()

# Add in code to pause game, hide this hud, and open a menu HUD
func _on_MenuButton_pressed():
	$MainMenu.hide()
	$SettingsMenu.show()

func _on_StartButton_pressed():
	$MainMenu/StartButton.hide()
	$MainMenu/MenuButton.hide()
	$MainMenu/ExitGameLabel.hide()
	
	emit_signal("start_game")

func _on_RainbowBeam_charging():
	print("rainbow beam charging")
	$MainMenu/PowerUpIndicator.hide()
	$MainMenu/ChargingIndicator.set_process(true)

func _on_ShowCreditsButton_pressed():
	$SettingsMenu/CreditsLayer.show()


func _on_BackToGameButton_pressed():
	$SettingsMenu.hide()
	$MainMenu.show()


func _on_ExitCredits_pressed():
	$SettingsMenu/CreditsLayer.hide()
	

func _on_Player_special_avilable():
	print("Player has new special")
	$MainMenu/PowerUpIndicator.show()


func _on_Player_player_hit(health):
	update_health(health)


func _on_EnemyController_level_up(level):
	update_level(level)


func _on_ExitLicense_pressed():
	$SettingsMenu/LicenseLayer.hide()


func _on_ShowLicenseButton_pressed():
	$SettingsMenu/LicenseLayer.show()


func _on_Player_upgrade_optained(max_health, speed, reload_time):
	var tween = $MainMenu/Tween
	if not tween.is_active():
    	tween.start()
	$MainMenu/Stats.show()
	$MainMenu/Stats.text = "Max Health: " + str(max_health) + "\nSpeed: " + str(speed) + " mph" + "\nReload: " + str(reload_time)
	tween.interpolate_property($MainMenu/Stats, "modulate", start_message, end_message, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)

