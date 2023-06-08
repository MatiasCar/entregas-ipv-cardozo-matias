extends Area2D


func _on_Killzone_body_entered(body: Player) -> void:
	body.notify_hit(body.max_hp)
