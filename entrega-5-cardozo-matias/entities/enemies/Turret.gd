extends Sprite

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene

var target:Node2D
var projectile:Sprite
var projectile_container

func _ready():
	fire_timer.connect("timeout", self, "fire_at_player")

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container


func fire_at_player():
	var proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))


func _on_AreaDeteccion_body_entered(body):
	if body is Player:
		target = body
		fire_timer.start()



func _on_AreaDeteccion_body_exited(body):
	fire_timer.stop()

