extends RigidBody2D
class_name PullableRigidBody

@export var friction: int
@export var item_name: String
func _ready():
	self.linear_damp = friction
	$Merge_aka_Craft_Area.common_name=item_name
	$Label.text = item_name

var pulled_toward: Vector2 = Vector2.ZERO
var pulled: bool = false

func _start_pulling(direction: Vector2):
	pulled_toward = direction
	$CollisionShape2D.disabled = true
	pulled = true
	self.sleeping = false

func _stop_pulling():
	pulled = false
	$CollisionShape2D.disabled = false
	self.sleeping = false

func _integrate_forces(state):
	if pulled:
		print("Pulled towards ", pulled_toward)
		state.apply_central_force(10000*self.global_position.direction_to(pulled_toward))
		#state.linear_velocity = 100*self.global_position.direction_to(pulled_toward).normalized()
