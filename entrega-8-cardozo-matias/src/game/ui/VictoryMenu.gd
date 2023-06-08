extends Control


func _ready() -> void:
	GameState.connect("level_won", self, "_on_level_won")
	hide()


func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false


func _on_level_won() -> void:
	show()
