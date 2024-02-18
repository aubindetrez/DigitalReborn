# it lets the player control the parent node

extends Node
class_name Controller

@export var speed: int = 10000
@export var active: bool = true # Can be used to disable controller in gui window...

var parent: CharacterBody2D
@export var toBeRotated: AnimationController
@export var area2dToRotate: Area2D

signal attack() # emitted when the user press ui_select

func _ready():
	parent = get_parent()
	assert(parent is CharacterBody2D, "controller must have a CharacterBody3D as parent to control")

func _physics_process(delta):
	if active:
		update_position(delta)
		
func _unhandled_key_input(event):
	if active:
		compute_strength(event)

# Keep track of the user inputs 
var right_strength = 0.0
var left_strength = 0.0
var up_strength = 0.0
var down_strength = 0.0
func compute_strength(event):
	if event.is_action_pressed("ui_right"):
		right_strength = event.get_action_strength("ui_right")
	elif event.is_action_released("ui_right"):
		right_strength = 0.0
	
	if event.is_action_pressed("ui_left"):
		left_strength = event.get_action_strength("ui_left")
	elif event.is_action_released("ui_left"):
		left_strength = 0.0
	
	if event.is_action_pressed("ui_down"):
		down_strength = event.get_action_strength("ui_down")
	elif event.is_action_released("ui_down"):
		down_strength = 0.0
	
	if event.is_action_pressed("ui_up"):
		up_strength = event.get_action_strength("ui_up")
	elif event.is_action_released("ui_up"):
		up_strength = 0.0
	
	if event.is_action_pressed("ui_select"): # attack / action
		attack.emit()
		active = false # block action until the attack is done

var velocity = Vector2(0, 0)
# Uses the results of compute_strength to more the parent
func update_position(delta):
	var userControl = Vector2.ZERO
	userControl.x = right_strength - left_strength
	userControl.y = down_strength - up_strength

	velocity = velocity.lerp(userControl.normalized() * speed * delta, 0.1)
	parent.velocity = velocity
	parent.move_and_slide()

	#if velocity.length() >= 1:
	var target_angle = atan2(velocity.x, -velocity.y)
	#var rot = toBeRotated.get_rotation()
	#rot = lerp_angle(rot, target_angle, 0.1)
	toBeRotated.set_rotation(target_angle)
	area2dToRotate.set_rotation(target_angle)

func _on_change_anim_based_on_mvmnt_anim_attack_finished():
	active = true
