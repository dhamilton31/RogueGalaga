extends CanvasModulate

var stages = 9
var charge_time = 1.5 # seconds per charge
var stages_per_second = stages/charge_time # stages per second per charge
var current_stage = 0
var elapsed_time = 0
var charged = false
var first_time = true

signal charged

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	for child in get_children():
		child.hide()
	set_process(false)

func _process(delta):
	
	if(first_time):
		first_time = false
	else:
		elapsed_time += delta

	current_stage = floor(elapsed_time * stages_per_second) # s * stages / s / charge = uhhh charge stages?
	
	if not charged:
		for node in get_children():
			if node.name.ends_with(str(current_stage)) and not node.visible:
				node.show()
				#print(node.name + " visibility: " + str(node.visible) + str(node.position))
			
	if charged:
		if charge_time - elapsed_time >= 0:
			for child in get_children():
				child.modulate = Color(1,1,1,(charge_time-elapsed_time)/charge_time)

		else:
			set_process(false)
			hide()
				
	
	if current_stage == stages and not charged:
		#print("Sending charged signal. Current stage: " + str(current_stage))
		emit_signal("charged")
		charged = true
		elapsed_time = delta

func reset_charger():
	current_stage = 0
	elapsed_time = 0
	charged = false
	first_time = true
	for child in get_children():
		child.hide()
		child.modulate = Color(1,1,1,1)

func _on_RainbowBeam_charging():
	#print("Chariging indicator - _on_RainbowBeam_charging:")
	reset_charger()
	show()
	set_process(true)