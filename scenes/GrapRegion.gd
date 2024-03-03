extends Area2D
class_name GrapRegion
# When activated, will grab an object

var can_grab: DroppedItem = null
var grabbing: DroppedItem = null
@export var target: Node2D

@export var activate: bool = false:
	get:
		return activate
	set(value):
		if value:
			drag_object(can_grab)
		else:
			drop_object()
			

func _process(delta):
	handle_inputs()
	if grabbing and is_instance_valid(grabbing):
		grabbing.get_parent()._start_pulling(target.global_position)

func drop_object():
	if not grabbing:
		return # Nothing to do
	# TODO Remove the physic used to pull the object
	grabbing.get_parent()._stop_pulling()
	print("Dropping ",grabbing.common_name)
	grabbing = null

func drag_object(obj: DroppedItem):
	if grabbing:
		drop_object()
	if not obj:
		return # No new object to drag
	grabbing = obj
	# TODO Use physic to pull the object
	grabbing.get_parent()._start_pulling(target.global_position)
	print("Pulling ",grabbing.common_name)

func handle_inputs():
	if Input.is_action_just_pressed("ui_accept"):
		activate = true
	elif Input.is_action_just_released("ui_accept"):
		activate = false

func _on_area_entered(area: DroppedItem):
	print("Can grab: ", area.common_name)
	can_grab = area

func _on_area_exited(area):
	can_grab = null
