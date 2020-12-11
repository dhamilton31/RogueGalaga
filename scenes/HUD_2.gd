extends CanvasLayer

signal start_game
signal open_menu

var default_text = "Rogue + Galaga"

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.show()
	$SettingsMenu.hide()
	$SettingsMenu/CreditsLayer.hide()

func show_message(text):
	$MainMenu/MessageLabel.text = text
	$MainMenu/MessageLabel.show()
	$MainMenu/MessageTimer.start()

func show_game_over():
	show_message("Game over")
	yield($MainMenu/MessageTimer, 'timeout')
	$MainMenu/MessageLabel.text = default_text
	$MainMenu/MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$MainMenu/StartButton.show()
	$MainMenu/MenuButton.show()
	$MainMenu/ExitGameLabel.show()
	
func update_score(score):
	$MainMenu/ScoreLabel.text = 'Score: ' + str(score)
	
func update_level(level):
	$MainMenu/LevelLabel.text = 'Level: ' + str(level)

func update_health(health):
	$MainMenu/LevelLabel.text = 'Level: ' + str(level)

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
	$"MainMenu/Charging Indicator".set_process(true)

func _on_ShowCreditsButton_pressed():
	$SettingsMenu/CreditsLayer.show()


func _on_BackToGameButton_pressed():
	$SettingsMenu.hide()
	$MainMenu.show()


func _on_ExitCredits_pressed():
	$SettingsMenu/CreditsLayer.hide()

func _on_ExitLicense_pressed():
	$SettingsMenu/LicenseLayer.hide()


func _on_GodotLicenseButton_pressed():
	$SettingsMenu/LicenseLayer.show()
