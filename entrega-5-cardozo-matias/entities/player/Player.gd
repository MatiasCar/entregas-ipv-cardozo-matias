extends KinematicBody2D
class_name Player

onready var cannon = $Cannon

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (float) var JUMP_SPEED:float = -400
export (float) var GRAVITY:float = 10

var velocity:Vector2 = Vector2.ZERO
var projectile_container

func set_projectile_container(projectile_container):
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container


func _get_input():
# Cannon rotation
	var mouse_position:Vector2 = get_global_mouse_position()
	
	# Manera compleja (Usando matemática de vectores)
	#var mouse_cannon_orientation:Vector2 = mouse_position - cannon.global_position
	#cannon.rotation = mouse_cannon_orientation.angle()
	
	# Manera abreviada (Usando funcion built-in)
	cannon.look_at(mouse_position)
	
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = owner
			cannon.projectile_container = projectile_container
		cannon.fire()
	
	# Player movement
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED


func _physics_process(delta):
	_get_input()
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	#position += velocity * delta


func _on_Area2D_body_entered(body):
	print(body)
	if body is Projectile:
		queue_free()
