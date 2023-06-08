extends KinematicBody2D

signal hit(amount)

onready var fire_position: Node2D = $FirePosition
onready var raycast: RayCast2D = $RayCast2D
onready var body: AnimatedSprite = $Body
onready var remove_anim_player: AnimationPlayer = $RemoveAnimPlayer

export (PackedScene) var projectile_scene
export (Vector2) var gravity: Vector2

var velocity: Vector2 = Vector2.ZERO

var target
var projectile_container

export (NodePath) var pathfinding_path: NodePath
onready var pathfinding: PathfindAstar = get_node_or_null(pathfinding_path)

var dead: bool = false


func initialize(container, turret_pos, projectile_container: Node = get_parent()) -> void:
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container


func fire() -> void:
	if target != null:
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))


func _play_animation(animation_name:String):
	if (body.frames.has_animation(animation_name) && !(body.animation == animation_name && body.frames.get_animation_loop(animation_name))):
		body.play(animation_name)


func apply_movement() -> void:
	velocity.y += 20
	velocity = move_and_slide(velocity)


func _can_see_target() -> bool:
	if target == null:
		return false
	raycast.set_cast_to(to_local(target.global_position))
	raycast.force_raycast_update()
	return raycast.is_colliding() && raycast.get_collider() == target


func notify_hit(amount: int = 1) -> void:
	emit_signal("hit", amount)


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()
