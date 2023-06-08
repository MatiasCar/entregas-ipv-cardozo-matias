extends Node

export (Array, PackedScene) var levels: Array
export (String) var main_menu_path: String

onready var current_level_container: Node = $CurrentLevelContainer

var level: int = 0


func _ready() -> void:
	call_deferred("_setup_level", level)


func _setup_level(id: int) -> void:
	if id >= 0 && id < levels.size():
		if current_level_container.get_child_count() > 0:
			for child in current_level_container.get_children():
				current_level_container.remove_child(child)
				child.queue_free()
		
		var level_instance: GameLevel = levels[id].instance()
		current_level_container.add_child(level_instance)


func _return_called() -> void:
	get_tree().paused = false
	get_tree().change_scene(main_menu_path)


func _restart_called() -> void:
	_setup_level(level)


func _next_called() -> void:
	level = min(level + 1, levels.size() - 1)
	_setup_level(level)
