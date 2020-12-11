extends Path2D

onready var follow = get_node("EnemyPosition")
export var enemy_speed = 225
var offset # This is emblematic of me (DG) not understanding the intricacies of position vs global position
var spawn_position_index
# Or really curve2D's at all

# Called when the node enters the scene tree for the first time.
func _ready():
	$Delay.connect("timeout", self, "_on_Delay_timeout")
	randomize()
	#set_process(false) # Path currently DISABLED!
	
func start(delay_max_time, target, spawn_position):
	#print("Max delay time: " + str(delay_max_time))
	set_path([Vector2(0,0), target])#randf()*1080.0, 128.0)])
	offset = target
	spawn_position_index = spawn_position
	#print(self.is_processing())
	#set_process(true)
	#print(self.is_processing())
	var offset_time = 5.0
	$Delay.start(rand_range(offset_time, offset_time + delay_max_time))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow.set_offset(follow.get_offset() + enemy_speed * delta)

func _on_Delay_timeout():
	#_set_path([self.position, Vector2(800,800)])
	#set_process(false)
	set_path([offset, offset + Vector2(0,1500)])#[self.position, self.position + Vector2(0.0, 500.0)])#
	follow.set_offset(0)
	get_parent().get_parent().get_node("EnemySpawnPoints").get_child(spawn_position_index).occupied = false
	#set_process(true)
	#set_process(true)
	#$Delay.disconnect("timeout", self, "_on_Delay_timeout")

func set_path(points):
	#print(curve.get_baked_points())
	#self.set_process(false)

	var new_curve = Curve2D.new()
	#curve.clear_points()
	for point in points:
		new_curve.add_point(point)
	self.curve = new_curve
	#self.set_process(true)