extends Area2D
const UPGRADE = preload("res://scenes/upgrades/Upgrade.tscn")

var velocity = Vector2(0, 300)
var drop_types = ["health", "upgrade", "beam"]
# percentage chance of getting each type of drop
# Will be health by default
export(int, 0, 50) var percentage_upgrade_drop = 5
export(int, 0, 50) var percentage_beam_drop = 20
var percentage_health_drop
var drop_type_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_to_group("upgradeDrop")
	determine_drop_type()

func _process(delta):
	global_position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func upgrade_obtained():
	queue_free()
	
func determine_drop_type():
	var value = randi() % 100
	# upgrade chance
	if(value < percentage_upgrade_drop):
		drop_type_index = 1
		var upgrade = UPGRADE.instance()
		add_child(upgrade)
	# beam chance
	elif(value > percentage_upgrade_drop && value < (percentage_upgrade_drop + percentage_beam_drop)):
		drop_type_index = 2
	print("Updgrade drop type: " + drop_types[drop_type_index])
	$AnimatedSprite.animation = drop_types[drop_type_index]
	
func get_upgradde_type():
	return drop_types[drop_type_index]
	
func get_upgrade():
	if(is_instance_valid($Upgrade)):
		return $Upgrade