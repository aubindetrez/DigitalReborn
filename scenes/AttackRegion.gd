extends Area2D
class_name AttackRegion # Area2D to produce attack

var attack_strenght = 0 # strength of the current attack (or last one)

# Called when we start an attack
func _on_controller_attack(strenght):
	attack_strenght = strenght
	self.monitoring = true

# Called when the attack ends
func _on_body_entered(body):
	if body is HitBox:
		body._receive_attack(attack_strenght)
	if body is HitBoxBuild:
		body._receive_build()

func _on_change_anim_based_on_mvmnt_anim_attack_finished():
	self.monitoring = false
