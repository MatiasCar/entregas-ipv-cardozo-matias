extends Sprite


export var speed = 200
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction: int = 0
	
	if Input.is_action_pressed("move_right"):
		direction = 1
	
	if Input.is_action_pressed("move_left"):
		direction = -1

	position.x += direction * speed * delta

