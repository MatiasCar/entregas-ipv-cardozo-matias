extends AbstractEnemyState

onready var fire_timer:Timer = $FireTimer

export (NodePath) var attack_sfx_path: NodePath
onready var attack_sfx: AudioStreamPlayer2D = get_node(attack_sfx_path)


func notify_body_exited(body) -> void:
	.notify_body_exited(body)
	if character.target == null:
		if character.body.animation == "shoot":
			yield(character.body, "animation_finished")
		emit_signal("finished", "idle")


func enter() -> void:
	character.velocity.x = 0
	_fire()


func exit() -> void:
	fire_timer.stop()


func update(delta) -> void:
	var can_see_target:bool = character._can_see_target()
	if fire_timer.is_stopped() && can_see_target && character.body.animation != "shoot":
		_fire()
	elif !fire_timer.is_stopped() && !can_see_target:
		fire_timer.stop()
	
	if can_see_target:
		character.body.flip_h = character.global_position.direction_to(character.target.global_position).x < 0


func _on_animation_finished(anim_name: String) -> void:
	if character.body.animation == "shoot":
		character._play_animation("idle")


func _on_FireTimer_timeout() -> void:
	if character._can_see_target():
		_fire()


func _fire() -> void:
	character.fire()
	fire_timer.start()
	character._play_animation("shoot")
	attack_sfx.play()
