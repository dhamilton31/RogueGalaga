extends "res://scenes/ships/ship.gd"

signal destroyed
const UPGRADE_DROP = preload("res://scenes/upgrades/UpgradeDrop.tscn")
export var upgrade_drop_chance_percentage = 15
export var damage = 25
var enemy_level = 1
const ENEMY_MAX_LEVEL = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Visibility.connect("screen_exited", self, "_on_Visibility_screen_exited")
	$".".connect("area_entered", self, "_on_Enemy_area_entered")
	add_to_group("enemies")
	$AnimatedSprite.play("Level1Normal")
	get_node("/root/main").connect("game_over", self, "_on_game_over")

func _on_Visibility_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()
	
func _on_game_over():
	queue_free()

func _on_Enemy_area_entered(area):
	if(area.is_in_group("player")):
		if(area.is_in_group("laser")):
			health -= area.get_damage_amount()
			$AnimatedSprite.play("Level" + str(enemy_level) + "Hit")
			$DamageTimer.start()
			$EnemyHit.play()
		else:
			health = 0
		# print("Enemy health: " + str(health))
		if(health <= 0):
		#print("Enemy hit by " + area.name)
			emit_signal("destroyed")
			chance_spawn_upgrade()
			#print("Enemy destroyed emitted from enemy")
			queue_free()

func get_damage_amount():
	return damage

func set_enemy_level(level):
	if(level > ENEMY_MAX_LEVEL):
		level = ENEMY_MAX_LEVEL
	enemy_level = level
	set_max_health(max_health * level)
	$AnimatedSprite.play("Level" + str(level) + "Normal")

func set_max_health(new_max_health):
	if(new_max_health > 0):
		max_health = new_max_health
		health = max_health
		print("Enemy max health set to: " + str(max_health))

func chance_spawn_upgrade():
	if((randi() % 100) < upgrade_drop_chance_percentage):
		print("Generating upgrade")
		var upgrade = UPGRADE_DROP.instance() # Creates a new instance of the laser scene
		upgrade.global_position = global_position # Move the new laser to the player's position
		print("parent name: " + get_parent().name)
		get_node("/root").add_child(upgrade) # Returns error "Can't change this state while flushing queries. Use call_deferred() or set_deferred() to change monitorin state instead"

func _on_DamageTimer_timeout():
	$AnimatedSprite.play("Level" + str(enemy_level) + "Normal")
