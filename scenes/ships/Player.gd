extends "res://scenes/ships/ship.gd"

# Allows the player class to create instances of laser class
const LASER = preload("res://scenes/lasers/PlayerLaser.tscn")
const BEAM = preload("res://scenes/lasers/RainbowBeam.tscn")

enum WeaponType {LASER, BEAM}

signal player_hit(health)
signal has_died(lives)
signal special_avilable
signal upgrade_optained(max_health, speed, reload_time)
var playing = false
var involnerable = false
var lives = 1

var base_max_health
var base_speed
var base_reload_time
var base_damage

# Called when the node enters the scene tree for the first time.
func _ready():
	set_base_stats()
	hide()

func _process(delta):
	if playing:
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		if Input.is_action_pressed("ui_select") && ready_to_fire(delta):
			fire(WeaponType.LASER)
		if Input.is_action_pressed("ui_up"):
			fire(WeaponType.BEAM)

func set_base_stats():
	base_max_health = max_health
	base_reload_time = reload_time
	base_speed = speed
	print("Base stats saved")

func start(pos):
	position = pos
	#target = pos
	show()
	playing = true
	health = max_health
	if(is_instance_valid($RainbowBeam)):
		$RainbowBeam.queue_free()
	$AnimatedSprite.play("idle")
	involnerable = false
	
	var special_attack = BEAM.instance()
	add_child(special_attack)
	emit_signal("special_avilable")
	#$CollisionShape2D.disabled = false

func dies():
	hide()
	#$CollisionShape2D.disabled = true
	playing = false
	lives -= 1
	emit_signal("has_died", lives)


func fire(weapon):
	if weapon == WeaponType.LASER:
		var attack = LASER.instance() # Creates a new instance of the laser scene
		attack.set_damage_amount(damage_amount)
		attack.global_position = global_position # Move the new laser to the player's position
		get_parent().add_child(attack)
	elif weapon == WeaponType.BEAM && is_instance_valid($RainbowBeam):
		$RainbowBeam.charge()

func _on_Player_area_entered(area):
	if(area.is_in_group("upgradeDrop")):
		if(area.get_upgradde_type() == "health"):
			print("Got health")
			var heal_amount = 0.1 * max_health#area.get_health_drop()
			if(health + heal_amount > max_health):
				health = max_health
			else:
				health += heal_amount
			emit_signal("player_hit", health)
		elif(area.get_upgradde_type() == "beam"):
			print("Got beam")
			if(!is_instance_valid($RainbowBeam)):
				var special_attack = BEAM.instance()
				add_child(special_attack)
				emit_signal("special_avilable")
		elif(area.get_upgradde_type() == "upgrade"):
			print("Got upgrade")
			apply_upgrade(area.get_upgrade())
		area.upgrade_obtained()
	elif(area.is_in_group("enemies")):
		print("Player hit by " + area.get_name())
		player_take_damage(area.get_damage_amount())

# Handles damage. Doesn't need to check whether health will drop below zero, right?
# Also, calls "dies", so why does main also check if the game is over?
func player_take_damage(damage_amount):
	if(!involnerable):
		if((health - damage_amount) < 0):
			health = 0
		else:
			health -= damage_amount
			$playerHit.play()
		involnerable = true
		$AnimatedSprite.play("damage")
		$DamageTimer.start()
		print("Player Health remaining: " + str(self.health))
		emit_signal("player_hit", health)
		if(health <= 0):
			dies()

func _on_DamageTimer_timeout():
	$AnimatedSprite.play("idle")
	involnerable = false

func apply_upgrade(upgrade):
	if(is_instance_valid(upgrade)):
		max_health = base_max_health + upgrade.upgrade_health
		speed = base_speed + (upgrade.upgrade_speed * 10)
		
		# Was reload_time - ..., so the comparison and what's being set aren't the same.
		if(base_reload_time - (upgrade.upgrade_firing_rate / 150.0) > 0):
			reload_time = base_reload_time - (upgrade.upgrade_firing_rate / 150.0) #
		print("stats with upgrades - max health: " + str(max_health) + 
		" speed: " + str(speed) + " reload_time: " + str(reload_time))
		emit_signal("upgrade_optained", max_health, speed, reload_time)