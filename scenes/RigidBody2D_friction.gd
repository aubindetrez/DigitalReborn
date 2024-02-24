extends RigidBody2D

@export var friction: int
@export var item_name: String
func _ready():
	self.linear_damp = friction
	$Merge_aka_Craft_Area.common_name=item_name
	$Label.text = item_name
