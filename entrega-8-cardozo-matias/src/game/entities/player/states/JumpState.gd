extends AbstractState

onready var jump_sfx: AudioStreamPlayer = $JumpSfx

export (int) var jumps_limit:int = 1

var jumps:int = 0


func enter() -> void:
	character.snap_vector = Vector2.ZERO
	character.velocity.y = -character.jump_speed
	character._play_animation("jump")
	jump_sfx.play()


func exit() -> void:
	jumps = 0


func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("dash") && character.move_direction != 0 && character.dash_cooldown.is_stopped():
		emit_signal("finished", "dash")
	elif event.is_action_pressed("jump") && jumps < jumps_limit:
		jumps += 1
		character.velocity.y = -character.jump_speed
		character._play_animation("jump")


func update(delta) -> void:
	character._handle_cannon_actions()
	character._handle_move_input()
	if character.move_direction == 0:
		character._handle_deacceleration()
	character._apply_movement()
	if character.is_on_floor():
		if character.move_direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "walk")


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
			if character.current_hp <= 0:
				emit_signal("finished", "dead")
		"healed":
			character._handle_heal(value)
