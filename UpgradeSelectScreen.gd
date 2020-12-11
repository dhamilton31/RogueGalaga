extends CanvasLayer

var screen_size  # Size of the game window.
var outline_spacing = 10
var outline_dim = 64
var box_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_parent().size
	print("Screen size: " + str(screen_size))
	var start_pos = 0
	box_count = $UpgradeBoxes.get_child_count()
	var counter = 1
	var rowNum = 1
	var start_y = screen_size.y - outline_dim - outline_spacing
	var start_x = -300
	for node in $UpgradeBoxes.get_children():
		var sprite_width = node.texture.get_width()
		node.global_position = Vector2(start_x + sprite_width * counter, start_y + rowNum * outline_dim)
		print("Node moved to: " + str(node.global_position))
		counter += 1
		if(counter ==  ((box_count/2) + 1)):
			rowNum = 2
			counter = 1

func add_upgrade(new_upgrade):
	if($Upgrades.get_child_count() < $UpgradeBoxes.get_child_count()):
		$Upgrades.add_child(new_upgrade)

func show_upgrades():
	var count = 1
	for node in $Upgrades.get_children():
		if node.is_in_group("upgrade"):
			for upgrade_box in $UpgradeBoxes.get_children():
				if upgrade_box.name.ends_with(str(count)):
					node.global_position = upgrade_box.global_position
					node.show()
					count += 1
			
