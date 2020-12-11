extends Area2D

enum LaserType {LASER_PLAYER, LASER_ENEMY}
export var velocity = Vector2()
export(LaserType) var laserType
var damage = 0

func _ready():
	add_to_group("laser")
	if(laserType == LaserType.LASER_PLAYER):
		$LaserFX1.play()
		add_to_group("player")
		$AnimatedSprite.play("player_laser")
	elif(laserType == LaserType.LASER_ENEMY):
		add_to_group("enemies")
		$AnimatedSprite.play("enemy_laser")

func _process(delta):
	global_position += velocity * delta

func _on_Visibility_screen_exited():
    queue_free()


func _on_laser_area_entered(area):
	if(laserType == LaserType.LASER_PLAYER):
		if(area.is_in_group("enemies")):
			queue_free()
	elif(laserType == LaserType.LASER_ENEMY):
		if(area.is_in_group("player")):
			queue_free()

func set_damage_amount(damage_amount):
	damage = damage_amount
	
func get_damage_amount():
	return damage