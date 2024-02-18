extends Node
class_name AnimationController

var rotation= 0.0
# Change the parent's node's animation based on it's movement
var parent: AnimatedSprite2D

func get_rotation():
	return rotation
	
func set_rotation(rot):
	rotation = rot

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	assert(parent is AnimatedSprite2D, "The parent must be an animated sprite2d")


var smoothed_rot = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#       +/-PI
# -PI/2     PI/2
#        0
func _process(delta):
	smoothed_rot = lerp(rotation, smoothed_rot, 0.1)
	if smoothed_rot < (PI/2 - PI/4) and smoothed_rot > (-PI/2 + PI/4):
		parent.play("downward")
	elif smoothed_rot < (-PI/2 - PI/4) or smoothed_rot > (PI/2 + PI/4):
		parent.play("upward")
	elif smoothed_rot < (PI - PI/4) and smoothed_rot > (0 + PI/4):
		parent.flip_h = false
		parent.play("right")
	elif smoothed_rot > (-PI + PI/4) and smoothed_rot < (0 - PI/4):
		parent.flip_h = true
		parent.play("right")
