extends Area2D
signal hit

export var max_health = 100
var health
export var speed = 100 # speed in pixels/sec
var screen_size  # Size of the game window.
export var reload_time = 0.2
var reloading = 0.0
var armor = 0
var damage_amount = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	screen_size = get_viewport_rect().size

func ready_to_fire(delta):
	reloading -= delta
	if reloading <= 0.0:
		reloading = reload_time
		return true
	else:
		return false
	
func get_damage_amount():
	return damage_amount