extends AbstractState

export (float) var dash_time: float = 1.0
export (float) var speed_multiplier: float = 1.0
export (float) var dash_cooldown: float = 1.0

export (Color) var dash_cooldown_color: Color

var dash_timer:Timer


func _ready() -> void:
	dash_timer = Timer.new()
	add_child(dash_timer)
	dash_timer.one_shot = true
	dash_timer.connect("timeout", self, "_on_dash_timer_timeout")


func _process(delta: float) -> void:
	var time_left: float = character.dash_cooldown.time_left
	character.body.self_modulate = lerp(Color.white, dash_cooldown_color, time_left / dash_cooldown)
	if time_left == 0:
		set_process(false)


func enter() -> void:
	dash_timer.start(dash_time)
	character._play_animation("jump", false, 2.0)
	character.effects_animation.play("dash")
	character.dash_cooldown.start(dash_cooldown)
	set_process(true)


func exit() -> void:
	dash_timer.stop()


func update(delta) -> void:
	character._handle_cannon_actions()
	character.velocity.x = clamp(
		character.velocity.x + (character.move_direction * character.ACCELERATION * speed_multiplier),
		-character.H_SPEED_LIMIT * speed_multiplier,
		character.H_SPEED_LIMIT * speed_multiplier
	)
	character._apply_movement()


func _on_dash_timer_timeout() -> void:
	character._handle_move_input()
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
