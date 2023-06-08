extends AbstractStateMachine


func _ready() -> void:
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"jump": $Jump,
		"dead": $Dead,
		"dash": $Dash
	}


func notify_hit(amount: int) -> void:
	current_state.handle_event("hit", amount)


func notify_healed(amount: int) -> void:
	current_state.handle_event("healed", amount)
