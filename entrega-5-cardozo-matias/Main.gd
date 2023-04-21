extends Node

onready var player = $Player
onready var turret_spawner = $TurretsSpawner

func _ready():
	randomize()
	player.set_projectile_container(self)
