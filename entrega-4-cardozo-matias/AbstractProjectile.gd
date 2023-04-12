extends Sprite


class_name Projectile

#signal delete_requested(projectile)

export var speed = 200

var direction:Vector2

func _ready():
	set_physics_process(false)


func set_starting_values(starting_position:Vector2, direction:Vector2):
	global_position = starting_position
	self.direction = direction
	#$Timer.start()
	set_physics_process(true)
	
	
func _physics_process(delta):
	position += direction*speed*delta
	


func _on_Timer_timeout():
	#emit_signal("delete_requested")
	queue_free()
