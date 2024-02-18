extends Marker2D

#@onready var tween = $Tween
var velocity = Vector2(50,100)
var gravity = Vector2(0,1)
var mass = 200
var item_name: String = "ITEM X":
	set(name):
		$Label.text = str(name)
	get:
		return $Label.text

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops()
	
	tween.tween_property(self, "modulate",
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		0.7
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale",
		Vector2(1.0, 1.0),
		0.3
	).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale",
		Vector2(0.4, 0.4),
		0.6
	).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(self.queue_free)
	
	#tween.start()
	tween.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += gravity * mass * delta
	position += velocity * delta
