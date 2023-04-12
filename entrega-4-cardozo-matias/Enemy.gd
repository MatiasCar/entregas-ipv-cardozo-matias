extends Sprite

export (PackedScene) var projectile_scene:PackedScene

onready var posicionDisparo: Position2D = $PosicionDisparo

var player


var projectile_container:Node



func set_values(player, projectile_container):
	self.player = player
	self.projectile_container = projectile_container
	$Timer.start()	


func _on_Timer_timeout():
	fire()
	
	

func fire():
	var projectile:Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile)
	projectile.set_starting_values(posicionDisparo.global_position, (player.global_position - posicionDisparo.global_position).normalized())
