extends Area2D


func _on_HealingGem_body_entered(body: Node) -> void:
	if body is Player:
		body.heal()
	call_deferred("_remove")


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()
