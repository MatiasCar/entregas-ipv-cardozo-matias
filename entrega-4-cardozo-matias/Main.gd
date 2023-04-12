extends Node

export(PackedScene) var enemy_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_projectile_container(self)
	$Enemy.set_values($Player, self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
