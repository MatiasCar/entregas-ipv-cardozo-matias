extends AbstractState


func enter() -> void:
	character._play_animation("walk", false)


func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("jump") && character.is_on_floor():
		emit_signal("finished", "jump")
	elif event.is_action_pressed("dash") && character.dash_cooldown.is_stopped():
		emit_signal("finished", "dash")


func update(delta) -> void:
	character._handle_cannon_actions()
	character._handle_move_input()
	character._apply_movement()
	if character.move_direction == 0:
		emit_signal("finished", "idle")
	else:
		if character.is_on_floor():
			character._play_animation("walk", false)
		else:
			character._play_animation("jump", false)


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
			if character.current_hp <= 0:
				emit_signal("finished", "dead")
		"healed":
			character._handle_heal(value)
