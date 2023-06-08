extends Node2D

onready var lifetime_timer = $LifetimeTimer
onready var hitbox = $Hitbox

export (float) var VELOCITY:float = 800.0

export (NodePath) var projectile_anim_path: NodePath
onready var projectile_anim: AnimationPlayer = get_node_or_null(projectile_anim_path)

var direction:Vector2


func initialize(container, spawn_position:Vector2, direction:Vector2) -> void:
	container.call_deferred("add_child", self)
	yield(self, "ready")
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()
	if projectile_anim:
		projectile_anim.play("shoot")


func _physics_process(delta) -> void:
	position += direction * VELOCITY * delta


func _on_lifetime_timer_timeout() -> void:
	call_deferred("_remove")


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


func _on_Hitbox_body_entered(body) -> void:
	if body.has_method("notify_hit"):
		body.notify_hit()
	hitbox.collision_mask = 0
	call_deferred("_remove")

