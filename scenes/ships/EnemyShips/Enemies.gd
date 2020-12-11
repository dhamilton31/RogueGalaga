extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawn_points
var num_spawn_points
var level = 1
export var enemies_per_level = 3
export var enemy_start_delay_time = 5
var enemy_delay_subtract_on_level_up = 1
var enemy_delay_time
const enemy_scene = preload("res://scenes/ships/Enemy.tscn")
const enemy_with_path = preload("res://scenes/ships/Enemy_with_Path.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_points = $EnemySpawnPoints.get_children()
	num_spawn_points = $EnemySpawnPoints.get_child_count()
	enemy_delay_time = enemy_start_delay_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn_enemies(level):
	randomize()
	
	var num_enemies_to_spawn = min(level * enemies_per_level, num_spawn_points)
	var enemy_spots_unused = range(num_spawn_points)
	for i in range(num_enemies_to_spawn):
	
		var enemy_position = randi() % num_spawn_points
		if enemy_spots_unused.has(enemy_position):
			enemy_spots_unused.remove(enemy_position)
		
			var new_enemy = enemy_with_path.instance()
			new_enemy.position = spawn_points[enemy_position].position
			print("Start with delay: " + enemy_delay_time)
			new_enemy.start(enemy_delay_time)
			$Enemies.add_child(new_enemy)
		
		pass
	pass

func level_up():
	if((enemy_delay_time - enemy_delay_subtract_on_level_up) >= 0):
		enemy_delay_time -= enemy_delay_subtract_on_level_up
		print("Enemy delay now set to: " + str(enemy_delay_time))

func _on_EnemyTimer_timeout():
	#var mob = Enemy.instance()
	
	#add_child(mob)
	#var direction = PI / 2
	#mob.position = Vector2(rand_range(0, screen_width), -16)
	#mob.rotation = direction
	#mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	#mob.linear_velocity = mob.linear_velocity.rotated(direction)
	#$HUD.connect('start_game', mob, '_on_start_game')
	pass