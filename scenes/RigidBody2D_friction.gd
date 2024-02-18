extends RigidBody2D

@export var friction: int
func _ready():
	self.linear_damp = friction
