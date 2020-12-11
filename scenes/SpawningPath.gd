extends Path2D

onready var follow = get_node("Spawner")
export var speed = 200
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Delay.connect("timeout", self, "_on_Delay_timeout")
	
	#randomize()
	#set_process(false) # Path currently DISABLED!
	# Based on https://godotengine.org/qa/9758/timer-node-how-to-use-it-in-code
	# Just one option for making timers
	pass
	
#func start(delay_max_time):
	#print("Max delay time: " + str(delay_max_time))
	#$Delay.start(rand_range(0.0, delay_max_time))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#follow.set_offset(follow.get_offset() + speed * delta)

func _on_timer_timeout():
	#set_process(true)
	#spawn()
	pass
