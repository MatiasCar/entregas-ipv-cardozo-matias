extends AbstractEnemyState

onready var idle_timer:Timer = $IdleTimer
export (NodePath) var idle_sfx_path: NodePath
onready var idle_sfx: Node = get_node(idle_sfx_path)
onready var idle_sfx_timer: Timer = $IdleSfxTimer

export (PoolRealArray) var idle_sfx_delay: PoolRealArray


func _ready() -> void:
	idle_sfx_timer.start(rand_range(idle_sfx_delay[0], idle_sfx_delay[1]))


func notify_body_entered(body: Node) -> void:
	.notify_body_entered(body)
	if character._can_see_target():
		emit_signal("finished", "alert")


func enter() -> void:
	character.velocity = Vector2.ZERO
	character._play_animation("idle")
	idle_timer.start()


func update(delta:float) -> void:
	character.apply_movement()


func exit() -> void:
	idle_timer.stop()
	if idle_sfx_timer.is_stopped():
		idle_sfx.play()
		idle_sfx_timer.start(rand_range(idle_sfx_delay[0], idle_sfx_delay[1]))


func _on_IdleTimer_timeout() -> void:
	if character.target == null:
		emit_signal("finished", "walk")
