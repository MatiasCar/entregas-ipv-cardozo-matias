extends Node

var current_player: Player

signal updated_current_player(current_player)


func set_current_player(player: Player) -> void:
	current_player = player
	emit_signal("updated_current_player", current_player)


signal level_won()

func notify_level_won() -> void:
	emit_signal("level_won")
