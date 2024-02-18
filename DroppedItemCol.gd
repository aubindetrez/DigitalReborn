extends Area2D
class_name DroppedItem

@export var common_name: String
@onready var particules = $"../CPUParticles2D"

var list_posible_craft: Array[DroppedItem] = []

func _on_area_exited(area):
	print("Item:", common_name, "lost one possible merge")
	list_posible_craft.remove_at(list_posible_craft.find(area))
	self.queue_redraw()
	if list_posible_craft.size() == 0:
		particules.emitting = false

func _on_area_entered(area):
	print("Item:", common_name, "detected possible merge")
	list_posible_craft.append(area)
	self.queue_redraw()
	particules.emitting = true
