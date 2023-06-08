extends Control

onready var hp_progress: TextureProgress = $"%HPProgress"


func _ready() -> void:
	GameState.connect("updated_current_player", self, "_on_updated_current_player")


func _on_updated_current_player(current_player: Player) -> void:
	current_player.connect("hp_changed", self, "_on_current_player_hp_changed")
	var current_hp: int = current_player.current_hp
	var max_hp: int = current_player.max_hp
	_on_current_player_hp_changed(current_hp, max_hp)


func _on_current_player_hp_changed(current_hp: int, max_hp: int) -> void:
	hp_progress.max_value = max_hp
	hp_progress.value = current_hp
