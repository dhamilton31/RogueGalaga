extends "res://scenes/ships/Enemy.gd"

var target = null
export var chance_special_attack = 10
onready var effect = get_node("ArrivingEffect")
onready var sprite = get_node("AnimatedSprite")
export var arrival_speed = 1.0
export var arrival_offset = Vector2(0,500)
export var arrival_scale_speed = 1.0
export var arrival_scale = Vector2(1,3)
export var final_scale = Vector2(2,2)
export var final_scale_speed = 0.1

func _ready():
	effect.interpolate_property(self, 'scale', arrival_scale, final_scale, arrival_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
	#effect.interpolate_property(self, 'visibilty/opacity', 1, 0, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(self, "position", self.position, self.position + arrival_offset, arrival_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#effect.connect("tween_completed", self, "_on_arrival")

func start(_target):
	target = _target

	arrive()

func seekTarget():
	var desired = Vector2.ZERO
	if target:
		desired = (target.position - position).normalized() * speed
	return desired

func _process(delta):
	position.x += seekTarget().x * delta
	
func arrive():
	#effect.interpolate_property(sprite, 'transform/scale', sprite.get_scale(), Vector2(2.0, 2.0), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.start()
	print('Arrive called')
	
func _on_arrival(object, key):
	print("_on_arrival called")
	effect.disconnect("tween_completed", self, "_on_arrival")
	effect.remove_all()
	effect.interpolate_property(self, 'scale', self.get_scale(), final_scale, final_scale_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.start()
	