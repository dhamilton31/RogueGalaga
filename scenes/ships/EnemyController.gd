extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawn_points
var num_spawn_points
var level = 1
export var enemies_per_level = 3
export var enemies_per_level_up = 5
export var min_spawn_time = 0.5
export var starting_spawn_time = 5.0
var enemies_killed_this_level = 0
export var enemy_start_delay_time = 4
var enemy_delay_subtract_on_level_up = 0.1
var enemy_delay_time
const enemy_scene = preload("res://scenes/ships/Enemy.tscn")
const enemy_with_path = preload("res://scenes/ships/Enemy_with_Path.tscn")

var spawners

signal enemy_destroyed
signal level_up(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_points = $EnemySpawnPoints.get_children()
	num_spawn_points = $EnemySpawnPoints.get_child_count()
	enemy_delay_time = enemy_start_delay_time
	
	# Trivial at the moment, but thinking about more spawners running simultaneously
	spawners = [$SpawningPath/Spawner]#, $SpawningPath2/Spawner]
	
	$SpawnTimer.connect("timeout", self, "_on_SpawnTimer_timeout")
	
	$SpawningPath/Spawner.set_targets(spawn_points)
	#$SpawningPath2/Spawner.set_targets(spawn_points)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn_boss(level):
	print("-------------\nBoss fight entered\n--------------")
	level += 1
	emit_signal("level_up", level)
	pass

func _spawn_enemies(level):
	randomize()
	
	# Will become outmoded soon
	var num_enemies_to_spawn = min(level * enemies_per_level, num_spawn_points)
	
	for i in range(num_enemies_to_spawn):
		var spawner = randi() % spawners.size()
		spawners[spawner].spawn(enemy_with_path) #timer.start()#
#		$SpawningPath/Spawner.spawn(enemy_with_path)
	
	# Old way, spawns enemies at positions
#	var enemy_spots_unused = range(num_spawn_points)
#	for i in range(num_enemies_to_spawn):
#
#		var enemy_position = randi() % num_spawn_points
#		if enemy_spots_unused.has(enemy_position):
#			enemy_spots_unused.remove(enemy_position) # Something wrong here. Calling index out of range
#
#			var new_enemy = enemy_with_path.instance()
#			new_enemy.position = spawn_points[enemy_position].position
#			new_enemy.start(enemy_delay_time * floor(level / 2), Vector2(0,0))
#			$Enemies.add_child(new_enemy)
#			new_enemy.get_node("EnemyPosition").get_node("Enemy").connect("destroyed", self, "_on_Enemy_destroyed")
#			#print(new_enemy.get_node("EnemyPosition").get_node("Enemy").name)
#
#		pass
#	pass

func _on_Enemy_destroyed():
	emit_signal("enemy_destroyed")
	#print("Enemy destroyed emitted from controller")

func Enemy_destroyed():
	enemies_killed_this_level += 1
	if(enemies_killed_this_level >= enemies_per_level_up):
		enemies_killed_this_level = 0
		level += 1
		if((enemy_delay_time - enemy_delay_subtract_on_level_up) > 0):
			enemy_delay_time -= enemy_delay_subtract_on_level_up
			print("Enemy delay now set to: " + str(enemy_delay_time))
		if(($SpawnTimer.wait_time - 0.5) > min_spawn_time):
			$SpawnTimer.wait_time -= 0.5
			print("Timer wait time is now: " + str($SpawnTimer.wait_time))
		emit_signal("level_up", level)
		
func stop_spawning():
	$SpawnTimer.stop()

func start_spawning():
	$SpawnTimer.start()	

func _on_SpawnTimer_timeout():
	_spawn_enemies(level)
	print('Spawning Enemies')
	#var mob = Enemy.instance()
	
	#add_child(mob)
	#var direction = PI / 2
	#mob.position = Vector2(rand_range(0, screen_width), -16)
	#mob.rotation = direction
	#mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	#mob.linear_velocity = mob.linear_velocity.rotated(direction)
	#$HUD.connect('start_game', mob, '_on_start_game')
	#pass

func _on_new_game():
	for node in get_children():
		if(node.is_in_group("enemies")):
			node.queue_free()
	level = 1
	enemies_killed_this_level = 0
	_spawn_enemies(level)
	$SpawnTimer.wait_time = starting_spawn_time
	$SpawnTimer.start()
	enemy_delay_time = enemy_start_delay_time

func _on_game_over():
	stop_spawning()
	level = 1
	