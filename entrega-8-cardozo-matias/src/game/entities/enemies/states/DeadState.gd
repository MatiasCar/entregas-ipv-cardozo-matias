extends AbstractEnemyState

export (NodePath) var die_sfx_path: NodePath
onready var die_sfx: Node = get_node(die_sfx_path)


func enter() -> void:
	character._play_animation("dead")
	character.raycast.collision_mask = 0
	character.collision_layer = 0
	character.collision_mask = 0
	die_sfx.play()


func _on_animation_finished(anim_name) -> void:
	if character.body.animation == "dead":
		character.remove_anim_player.play("remove")
