extends Node
class_name AnimationController

var rotation= 0.0
# Change the parent's node's animation based on it's movement
var parent: AnimatedSprite2D

signal anim_attack_finished()

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
	var charbody2d: CharacterBody2D = $"../.."
	if blockingAnimAttack:
		pass
	elif charbody2d.velocity.length() > 10.0: # arbitrary number for when do we actually stopped moving
		anim_moving()
	else:
		anim_idle()

func anim_moving():
	parent.speed_scale = 2 # by default the movement is too fast compared to the animation, speed up the animation
	if smoothed_rot < (PI/2 - PI/4) and smoothed_rot > (-PI/2 + PI/4):
		parent.play("upward")
	elif smoothed_rot < (-PI/2 - PI/4) or smoothed_rot > (PI/2 + PI/4):
		parent.play("downward")
	elif smoothed_rot < (PI - PI/4) and smoothed_rot > (0 + PI/4):
		parent.flip_h = false
		parent.play("right")
	elif smoothed_rot > (-PI + PI/4) and smoothed_rot < (0 - PI/4):
		parent.flip_h = true
		parent.play("right")

func anim_idle():
	parent.speed_scale = 1
	if smoothed_rot < (PI/2 - PI/4) and smoothed_rot > (-PI/2 + PI/4):
		parent.play("idleup")
	elif smoothed_rot < (-PI/2 - PI/4) or smoothed_rot > (PI/2 + PI/4):
		parent.play("idledown")
	elif smoothed_rot < (PI - PI/4) and smoothed_rot > (0 + PI/4):
		parent.flip_h = false
		parent.play("idleright")
	elif smoothed_rot > (-PI + PI/4) and smoothed_rot < (0 - PI/4):
		parent.flip_h = true
		parent.play("idleright")

var blockingAnimAttack = false # Do not play any other animation if set
func anim_attack(strenght):
	blockingAnimAttack = true
	parent.speed_scale = 2
	if smoothed_rot < (PI/2 - PI/4) and smoothed_rot > (-PI/2 + PI/4):
		parent.play("attackup")
	elif smoothed_rot < (-PI/2 - PI/4) or smoothed_rot > (PI/2 + PI/4):
		parent.play("attackdown")
	elif smoothed_rot < (PI - PI/4) and smoothed_rot > (0 + PI/4):
		parent.flip_h = false
		parent.play("attackright")
	elif smoothed_rot > (-PI + PI/4) and smoothed_rot < (0 - PI/4):
		parent.flip_h = true
		parent.play("attackright")

func _on_player_sprite_animation_finished():
	anim_attack_finished.emit()
	blockingAnimAttack = false
