extends StaticBody2D
class_name HitBox # Detect hit by player, have life and drop resources

@export var audioPlayer: AudioStreamPlayer

func _ready():
	pass

func _process(delta):
	pass

func _receive_attack(power):
	print("Tree is hit by power:", power)
	audioPlayer.play()
