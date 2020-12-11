extends PathFollow2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200
var timer
var targets

const enemy_with_path = preload("res://scenes/ships/EnemyShips/Enemy_with_Path.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_rotate(false)
	set_loop(false)
	
	# For testing, mostly
	timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	#timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.set_offset(self.get_offset() + speed * delta)
	#print(self.get_offset())
	#print(self.get_unit_offset())
	if self.get_unit_offset() > 1.0 or self.unit_offset < 0.0:
		speed = -1 * speed
#	pass

func _on_timer_timeout():
	spawn(enemy_with_path)
	#print("Timeout")
	timer.stop()
	pass
	
func spawn(spawnable):
	#print("Spawning")
	var target_idx = randi() % targets.size()
	#print(target_idx)
	#print(targets[target_idx].get_children().size())
	if targets[target_idx].occupied:
		pass
		#target_idx = randi() % targets.size()
	targets[target_idx].occupied = true
		
		#print(target_idx)
		#print(targets[target_idx].get_children().size())

	var new_spawnable = spawnable.instance()
	
	#print(new_spawnable.position)
	new_spawnable.position = self.position
	#print(new_spawnable.position)
	#new_spawnable.position = spawn_points[enemy_position].position
	new_spawnable.start(2, targets[target_idx].position-self.position, target_idx)
	get_parent().get_parent().get_node("Enemies").add_child(new_spawnable)
	
	new_spawnable.get_node("EnemyPosition").get_node("Enemy").connect("destroyed", get_parent().get_parent(), "_on_Enemy_destroyed")
	get_parent().get_parent().connect("game_over", new_spawnable.get_node("EnemyPosition").get_node("Enemy"), "_on_game_over")
	return new_spawnable

func set_targets(new_targets):
	targets = new_targets
