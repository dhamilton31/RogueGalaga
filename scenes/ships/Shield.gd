extends Area2D

export var max_health = 100
var health
enum ShieldType {SHIELD_PLAYER, SHIELD_ENEMY}
export(ShieldType) var shield_type
signal shield_destroyed

func _ready():
	health = max_health

func set_shield_type(_shield_type):
	shield_type = _shield_type
	if(_shield_type == ShieldType.SHIELD_PLAYER):
		add_to_group("player")
	elif(_shield_type == ShieldType.SHIELD_ENEMY):
		add_to_group("enemies")

func _on_Shield_area_entered(area):
	if(area.is_in_group("laser")):
		if(shield_type == ShieldType.SHIELD_PLAYER):
			if(area.is_in_group("enemies")):
				take_damage(area.get_damage_amount())
		elif(shield_type == ShieldType.SHIELD_ENEMY):
			if(area.is_in_group("player")):
				take_damage(area.get_damage_amount())

func take_damage(damage_amount):
	health -= damage_amount
	$AnimatedSprite.play("shieldHit")
	$DamageTimer.start(1)
	print("Shield health: " + str(health) + "//" + str(max_health))
	if(health <= 0):
		emit_signal("shield_destroyed")
		queue_free()

func _on_DamageTimer_timeout():
	$AnimatedSprite.play("shield")
