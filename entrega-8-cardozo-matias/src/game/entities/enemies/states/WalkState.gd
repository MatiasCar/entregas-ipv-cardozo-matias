extends AbstractEnemyState

export (NodePath) var walk_sfx_path: NodePath
onready var walk_sfx: Node = get_node(walk_sfx_path)
onready var walk_sfx_timer: Timer = $WalkSfxTimer

export (Vector2) var wander_radius
export (float) var speed
export (float) var max_h_speed

var path:Array = []


func notify_body_entered(body: Node) -> void:
	.notify_body_entered(body)
	if character._can_see_target():
		emit_signal("finished", "alert")


func enter() -> void:
	var random_point:Vector2 = character.global_position + Vector2(rand_range(-wander_radius.x, wander_radius.x), rand_range(-wander_radius.y, wander_radius.y))
	if character.pathfinding != null:
		path = character.pathfinding.get_simple_path(character.global_position, random_point)
		if path.empty() || path.size() == 1:
			emit_signal("finished", "idle")
		else:
			character._play_animation("walk")
			walk_sfx_timer.start()
	else:
		emit_signal("finished", "idle")


func exit() -> void:
	path = []
	walk_sfx_timer.stop()


func update(delta) -> void:
	if path.empty():
		emit_signal("finished", "idle")
		return
	var next_point:Vector2 = path.front()
	while character.global_position.distance_to(next_point) < 32:
		path.pop_front()
		if path.empty():
			emit_signal("finished", "idle")
			return
		else:
			next_point = path.front()
	character.velocity.x = clamp((character.velocity.x + character.global_position.direction_to(next_point).x * speed), -max_h_speed, max_h_speed)
	character.apply_movement()
	
	character.body.flip_h =  character.velocity.x < 0


func _on_WalkSfxTimer_timeout() -> void:
	walk_sfx.play()
