extends "res://scenes/lasers/laser.gd"

func _on_PlayerLaser_area_entered(area):
	if(area.is_in_group("enemies")):
		queue_free()
