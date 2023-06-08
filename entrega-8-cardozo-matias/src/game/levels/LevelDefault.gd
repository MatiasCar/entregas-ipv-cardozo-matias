extends Node
class_name GameLevel


## You shouldn't load this scene directly, the LevelManager should do that for you.

## This script should be the same for all levels. If you need to extend it's functionality
## check if you either need it for all levels or just for that single level.

func _ready() -> void:
	randomize()
	$Bgm.play()
	$Foley.play()
