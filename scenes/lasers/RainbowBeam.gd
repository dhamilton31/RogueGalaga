extends Node2D

signal charging

export var charge_time = 2 # seconds per charge
var stages = 9
var stages_per_second = stages/charge_time # stages per second per charge
var current_stage = 0
var elapsed_time = 0
var fire_time = 3
#var charging = false
var firing = false
var is_charging = false
var alpha = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node(Main/HUD/ChargingIndicator).connect("charged", self, "_on_charged")
	#self.connect("charging", $ChargingIndicator, "_on_Beam_charging")
	hide()
	$CollisionShape2D.disabled = true
	add_to_group("player")
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	elapsed_time += delta

	if fire_time - elapsed_time >= 0:
		alpha = (fire_time-elapsed_time)/fire_time
		$"Beam".modulate = Color(1,1,1,alpha)
		if alpha <= 0.25 and not $CollisionShape2D.disabled:
			$CollisionShape2D.disabled = true
	else:
		print(self.name + " destroyed")
		queue_free()
	
func charge():
	if(!is_charging && !firing):
		emit_signal("charging")
		is_charging = true

func _on_charged():
	print("Fully charged: firing rainbow beam")
	set_process(true)
	$CollisionShape2D.disabled = false
	$laserSoundFX.play()
	show()
