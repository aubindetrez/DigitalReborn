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

var split_appart = false
var split_from = Vector2.ZERO
var split_dist = 0 # Splitting will desactivate itself when the distance if larger than this number
func _take_appart(center: Vector2, dist: int):
	_stop_pulling() # Desactivate pulling if the user what holding the item
	split_appart = true
	split_from = center
	split_dist = dist

func _integrate_forces(state):
	if pulled:
		print("Pulled towards ", pulled_toward)
		var d = self.global_position.distance_to(pulled_toward)
		state.apply_central_force(d*d*self.global_position.direction_to(pulled_toward))
		#state.linear_velocity = 100*self.global_position.direction_to(pulled_toward).normalized()
	if split_appart:
		var d = self.global_position.distance_to(split_from)
		if d > split_dist:
			split_appart = false
		else:
			var force = 100000.0/d
			if force > 1000:
				force = 1000
			state.apply_central_force(force * -1 * self.global_position.direction_to(split_from))
