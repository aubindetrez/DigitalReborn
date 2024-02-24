extends Area2D
class_name DroppedItem

@export var common_name: String
@onready var particules = $"../CPUParticles2D"

signal new_collision(item1: DroppedItem, item2: DroppedItem) # Emit whenever another item enters within merge distance
signal rm_collision(item1: DroppedItem, item2: DroppedItem)

func _ready():
	# When the item is dropped it connects to the CraftManager of the scene
	var manager: CraftManager = get_tree().get_current_scene().find_child("CraftManager", false)
	new_collision.connect(manager._callback_new_collision)
	rm_collision.connect(manager._callback_rm_collision)

func _stop_merge_anim():
	print("Item:", common_name, "cannot merge anymore")
	self.queue_redraw()
	particules.emitting = false

func _start_merge_anim():
	print("Item:", common_name, "can now merge")
	self.queue_redraw()
	particules.emitting = true

func _on_area_entered(area):
	new_collision.emit(self, area) # will play sound...

func _on_area_exited(area):
	rm_collision.emit(self, area)
