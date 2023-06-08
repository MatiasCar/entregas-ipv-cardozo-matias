extends Area2D


func _on_Trophy_body_entered(body) -> void:
	GameState.notify_level_won()
	print("You win!")
	call_deferred("_remove")


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()
