extends AbstractState
class_name AbstractEnemyState


func notify_body_entered(body: Node) -> void:
	if character.target == null:
		character.target = body


func notify_body_exited(body) -> void:
	if body == character.target:
		character.target = null

