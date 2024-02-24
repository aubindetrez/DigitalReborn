extends StaticBody2D
class_name HitBox # Detect hit by player, have life and drop resources

@export var audioPlayer: AudioStreamPlayer
@export var label: Label

@onready var timer: Timer = $Timer

func _ready():
	label.visible = false

func _receive_attack(_power):
	display_label_1s()
	audioPlayer.play()

	await audioPlayer.finished
	instanciate_item()

func display_label_1s():
	label.visible = true
	timer.wait_time = 1.0
	timer.start()

func _on_timer_timeout():
	label.visible = false

@export var drop_offset: Vector2 = Vector2(0, 70)
func instanciate_item():
	var drop_scene = preload("res://dropped_item.tscn")
	var instance = drop_scene.instantiate()
	instance.global_position = self.global_position - drop_offset
	instance.friction = 3
	instance.item_name = "rock"
	get_tree().get_current_scene().add_child(instance)
