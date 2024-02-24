extends StaticBody2D
class_name HitBox # Detect hit by player, have life and drop resources

@export var audioPlayer: AudioStreamPlayer
@export var item_name_to_drop: String

func _receive_attack(_power):
	audioPlayer.play()

	await audioPlayer.finished
	instanciate_item()

@export var drop_offset: Vector2 = Vector2(0, -70)
func instanciate_item():
	var drop_scene = preload("res://dropped_item.tscn")
	var instance = drop_scene.instantiate()
	instance.global_position = self.global_position - drop_offset
	instance.friction = 3
	instance.item_name = item_name_to_drop
	get_tree().get_current_scene().add_child(instance)
