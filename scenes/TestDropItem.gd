extends Button

var item_scene = preload("res://scenes/craftable_item.tscn")

func _pressed():
	var craftable_item = item_scene.instantiate()
	
	craftable_item.position = Vector2(480/2, 270/2)
	#item.velocity = Vector2(randf_range(-50, 50), -100)
	craftable_item.modulate = Color(
		randf_range(0.7, 1), randf_range(0.7, 1), randf_range(0.7, 1),
		1.0
	)
	
	### White
	#item.modulate = Color(1.0, 1.0, 1.0, 1.0)s
	
	var amount = randi()%10 - 5
	
	craftable_item.item_name = str(amount)
	
	if amount > 0:
		craftable_item.item_name = "+" + craftable_item.item_name
	
	add_child(craftable_item)


## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
#
