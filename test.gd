extends Marker2D

var item_scene = preload("res://craftable_item.tscn")

func createText():
	var item = item_scene.instance()
	
	item_scene.position = Vector2(480/2, 270/2)
	item_scene.velocity = Vector2(randf_range(-50, 50), -100)
	item_scene.modulate = Color(
		randf_range(0.7, 1), randf_range(0.7, 1), randf_range(0.7, 1),
		1.0
	)
	
	var amount = randi()%10 - 5
	item.text = amount
	if amount > 0:
		item.text = "+" + item.text
		
	add_child(item)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
