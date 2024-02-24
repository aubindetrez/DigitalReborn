extends StaticBody2D
class_name HitBoxBuild # Detect hit by player, Dispears and instantiate an object

@export var audioPlayer: AudioStreamPlayer

@onready var furnace_scene = preload("res://scenes/furnace.tscn")

# based on the name of the DroppedItem (parent), return the scena to instanciate (or null)
func get_scene_to_instanciate():
	match self.get_parent().item_name:
		"furnace":
			return furnace_scene
		_:
			return null

func _receive_build():
	audioPlayer.play()

	# TODO before the instanciation, try to move the DroppedItem so the instanciated scene will fit
	# TODO play a nice animation with smoke (particle emiter)
	await audioPlayer.finished
	var scene = get_scene_to_instanciate()
	if scene:
		self.get_parent().queue_free()
		instanciate_item(scene)
	else:
		print("Object ", self.get_parent().item_name, " cannot be built")
	
func instanciate_item(scene):
	var instance = scene.instantiate()
	instance.global_position = self.global_position.ceil() # ceil to avoid being between two pixels and having the instance slightly move between frames
	get_tree().get_current_scene().add_child(instance)
