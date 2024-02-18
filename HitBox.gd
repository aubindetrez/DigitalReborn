extends StaticBody2D
class_name HitBox # Detect hit by player, have life and drop resources

@export var audioPlayer: AudioStreamPlayer
@export var label: Label

@onready var timer: Timer = $Timer

func _ready():
	label.visible = false

func _process(delta):
	pass

func _receive_attack(power):
	display_label_1s()
	audioPlayer.play()

func display_label_1s():
	label.visible = true
	timer.wait_time = 1.0
	timer.start()

func _on_timer_timeout():
	label.visible = false
