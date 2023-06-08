extends KinematicBody2D
class_name Player

const FLOOR_NORMAL: Vector2 = Vector2.UP
const SNAP_DIRECTION: Vector2 = Vector2.DOWN
const SNAP_LENGTH: float = 32.0
const SLOPE_THRESHOLD: float = deg2rad(60)

signal hit(amount)
signal healed(amount)
signal hp_changed(current_hp, max_hp)
signal dead()

onready var body: Sprite = $Body
onready var slime: Sprite = $"%Slime"
onready var cannon_container: Node2D = $"%CannonContainer"
onready var cannon: Sprite = $"%Cannon"

onready var floor_raycasts: Array = $FloorRaycasts.get_children()
onready var body_animations: AnimationPlayer = $BodyAnimations
onready var effects_animation: AnimationPlayer = $EffectsAnimations
onready var dash_cooldown: Timer = $DashCooldown

export (int) var max_hp: int = 1
onready var current_hp: int = max_hp

export (float) var ACCELERATION:float = 30.0
export (float) var H_SPEED_LIMIT:float = 400.0
export (float) var jump_speed: float = 1000
export (float) var FRICTION_WEIGHT: float = 0.1
export (float) var gravity: float = 30

var projectile_container

var velocity: Vector2 = Vector2.ZERO
var snap_vector: Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var move_direction: int = 0
var stop_on_slope: bool = true


func _ready() -> void:
	initialize()


func initialize(projectile_container: Node = get_parent()) -> void:
	GameState.set_current_player(self)
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container


func _handle_move_input() -> void:
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if move_direction != 0:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)

	if move_direction < 0:
		body.flip_h = true
		body.offset.x = -50
	elif move_direction > 0:
		body.flip_h = false
		body.offset.x = 50


func _handle_deacceleration() -> void:
	velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0


func _handle_cannon_actions():
	var mouse_position_normalized:Vector2 = (get_global_mouse_position() - cannon.global_position).normalized()
	
	if mouse_position_normalized.x < 0:
		cannon_container.scale.x = -1
		mouse_position_normalized.x *= -1
	else:
		cannon_container.scale.x = 1
	
	cannon.rotation = mouse_position_normalized.angle()

	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()


func _apply_movement():
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, stop_on_slope, 4, SLOPE_THRESHOLD)
	if is_on_floor() && snap_vector == Vector2.ZERO:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH


func notify_hit(amount: int = 1) -> void:
	emit_signal("hit", amount)


func _handle_hit(amount: int) -> void:
	current_hp -= amount
	emit_signal("hp_changed", current_hp, max_hp)
	$StateMachine/Dead/HurtSfx.play()
	slime.self_modulate = lerp(Color.white, Color.red, 1.0 - (float(current_hp) / max_hp))
	effects_animation.play("hit")


func heal(amount: int = 1) -> void:
	emit_signal("healed", amount)


func _handle_heal(amount: int) -> void:
	current_hp = min(current_hp + 1, max_hp)
	emit_signal("hp_changed", current_hp, max_hp)
	effects_animation.play("heal")


func _remove():
	hide()
	collision_layer = 0


func is_on_floor()->bool:
	var is_colliding:bool = .is_on_floor()
	for raycast in floor_raycasts:
		raycast.force_raycast_update()
		is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding


func _is_animation_playing(animation_name:String)->bool:
	return body_animations.current_animation == animation_name && body_animations.is_playing()


func _play_animation(animation_name:String, should_restart:bool = true, playback_speed:float = 1.0):
	if body_animations.has_animation(animation_name):
		if should_restart:
			body_animations.stop()
		body_animations.playback_speed = playback_speed
		body_animations.play(animation_name)

