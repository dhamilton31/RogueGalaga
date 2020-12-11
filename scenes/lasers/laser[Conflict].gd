extends Area2D

enum LaserType {LASER_PLAYER, LASER_ENEMY}
export var velocity = Vector2()
export(LaserType) var laserType

func _ready():
	if(laserType == LaserType.LASER_PLAYER):
		$LaserFX1.play()
		add_to_group("player")

func _process(delta):
	global_position += velocity * delta

func _on_Visibility_screen_exited():
    queue_free()


func _on_laser_area_entered(area):
	if(area.is_in_group("enemies")):
		queue_free()