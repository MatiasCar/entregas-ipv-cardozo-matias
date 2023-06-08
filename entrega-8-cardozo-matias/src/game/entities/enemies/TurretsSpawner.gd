extends Control

export (PackedScene) var turret_scene
export (NodePath) var pathfinding_path: NodePath

onready var pathfinding: Node = get_node_or_null(pathfinding_path)


func _ready() -> void:
	call_deferred("_initialize")


func _initialize() -> void:
	for i in 3:
		var turret_instance = turret_scene.instance()
		
		var turret_pos:Vector2 = Vector2(
			rand_range(rect_position.x, rect_position.x + rect_size.x),
			rand_range(rect_position.y, rect_position.y + rect_size.y)
			)
		
		turret_instance.initialize(self, turret_pos, self)
		if pathfinding:
			turret_instance.pathfinding = pathfinding
