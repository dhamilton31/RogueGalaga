extends Node2D

# this number of health points are added on
var upgrade_health = 0
# Subtracts the armor value from enemy damage 
var upgrade_armor = 0
# adds the speed value * 10 
var upgrade_speed = 0
# increases damage delt by this amount
var upgrade_damage = 0
# subtracts this many ms from reload time
var upgrade_firing_rate = 0

export var main_upgrade_range_min = 15
export var other_upgrade_range_max = 5
export var main_upgade_range_max = 50
export var other_upgrade_range_min = -5

var num_upgrade_types = 3
enum UPGRADE_TYPE {HEALTH, FIRING_RATE, SPEED, DAMAGE, ARMOR}
export(UPGRADE_TYPE) var upgrade_type = UPGRADE_TYPE.HEALTH

func _ready():
	add_to_group("upgrade")
	randomize()
	# Upgrades will have a random value set by the above parameters. there will be a single
	# "main" parameter to have a larger upgrade, and smaller adjustment values for the 
	# remaining attributes
	determine_main_upgrade()
	randomizeValues()
	print("health: " + str(upgrade_health) + " armor " + str(upgrade_armor) +
	" speed " + str(upgrade_speed) + " damage: " + str(upgrade_damage) + 
	" firing rate: " + str(upgrade_firing_rate)) 
	
func randomizeValues():
	var randomVal = (other_upgrade_range_max) 
	upgrade_health = randi() % randomVal + other_upgrade_range_min
	upgrade_armor = randi() % randomVal + other_upgrade_range_min
	upgrade_speed = randi() % randomVal + other_upgrade_range_min
	upgrade_damage = randi() % randomVal + other_upgrade_range_min
	upgrade_firing_rate = randi() % randomVal + other_upgrade_range_min
	randomizeMainValue()

func randomizeMainValue():
	var main_random = (randi() % (main_upgade_range_max - main_upgrade_range_min)) + main_upgrade_range_min
	match upgrade_type:
		UPGRADE_TYPE.HEALTH:
			upgrade_health = main_random
			$AnimatedSprite.play("health_up")
		UPGRADE_TYPE.ARMOR:
			upgrade_armor = main_random
		UPGRADE_TYPE.SPEED:
			upgrade_speed = main_random
			$AnimatedSprite.play("speed_up")
		UPGRADE_TYPE.DAMAGE:
			upgrade_damage = main_random
			$AnimatedSprite.play("damage_up")
		UPGRADE_TYPE.FIRING_RATE:
			upgrade_firing_rate = main_random
			$AnimatedSprite.play("fr_up")
			
func determine_main_upgrade():
	upgrade_type = randi() % num_upgrade_types