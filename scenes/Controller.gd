# it lets the player control the parent node

extends Node
class_name Controller

@export var speed: int = 10000
@export var active: bool = true # Can be used to disable controller in gui window...

var parent: CharacterBody2D
@export var toBeRotated: AnimationController
@export var area2dToRotate: Area2D

signal attack(strengh: int) # emitted when the user press ui_select

func _ready():
	parent = get_parent()
	assert(parent is CharacterBody2D, "controller must have a CharacterBody3D as parent to control")

func _physics_process(delta):
	if active:
		handle_inputs() # _unhandled_key_input() only works for non-joystick event
		update_position(delta)
		
func handle_inputs():
	if Input.is_action_just_pressed("ui_select"): # attack / action
		attack.emit(inventory.strength)
		active = false # block action until the attack is done

var velocity = Vector2(0, 0) # static in order to use lerp
func update_position(delta):
	var userControl = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			).limit_length(1.0)

	velocity = velocity.lerp(userControl * speed * delta, 0.1)
	parent.velocity = velocity
	parent.move_and_slide()

	var target_angle = atan2(velocity.x, -velocity.y)
	toBeRotated.set_rotation(target_angle)
	area2dToRotate.set_rotation(target_angle)

@export var inventory: Inventory
func _on_change_anim_based_on_mvmnt_anim_attack_finished():
	active = true

var save_path = "user://score.save"
func _enter_tree():
	if ResourceLoader.exists(save_path):
		inventory = load(save_path)

func _exit_tree():
	ResourceSaver.save(inventory, save_path)
