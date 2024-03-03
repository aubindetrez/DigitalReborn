extends Control

var children = []
var selected = 0

@onready var selTex = $"../selectedTextures" # Highlight the selected texture

signal selection_changed() # any time the user makes a new selection

signal selection_confirmed(choice) # choice is from 0 to 2

# Called when the node enters the scene tree for the first time.
func _ready():
	children = self.get_children()
	for _i in children:
		assert(_i is TextureRect) # All childs needs to be a texture for the code to work

	selTex.visible = true
	selTex.scale = children[selected].scale
	selTex.global_position = children[selected].global_position

func _process(delta):
	handle_inputs()

func handle_inputs():
	if Input.is_action_just_pressed("ui_right"):
		selected = (selected+1) % children.size()
		selection_changed.emit()
	elif Input.is_action_just_pressed("ui_left"):
		selected = (selected-1) % children.size()
		selection_changed.emit()
	elif Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		selection_confirmed.emit(selected)
	selTex.scale = children[selected].scale
	selTex.global_position = children[selected].global_position
