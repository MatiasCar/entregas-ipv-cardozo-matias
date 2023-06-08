tool
extends Node2D
class_name AudioHandler2D

onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer

export (bool) var _test setget _set_test
export (int) var _test_index:int = 0 setget _set_test_ind

func _set_test_ind(id:int)->void:
	_test_index = clamp(id, 0, max(_audio_references.size()-1, 0))

func _set_test(_val:bool)->void:
	_test = false
	_run_test()

func _run_test()->void:
	if _audio_references.empty():
		return
	audio_stream_player = $AudioStreamPlayer
	play(0.0, _test_index)


export (Array, AudioStream) var _audio_references:Array setget _set_audio_ref
export (Array, float) var _db_volumes:Array setget _set_db_vol
export (Array, Array, float) var _pitch_scales:Array setget _set_pitch_sc
export (float, EASE) var _attenuation: float = 1.0 setget _set_attenuation
export (String) var _bus: String setget _set_bus

func _set_audio_ref(ref:Array)->void:
	_audio_references = ref

func _set_db_vol(vol:Array)->void:
	_db_volumes = vol

func _set_attenuation(att: float) -> void:
	_attenuation = att

func _set_pitch_sc(sc:Array)->void:
	_pitch_scales = sc

func _set_bus(bs:String) -> void:
	_bus = bs


## Functions

var timers:Dictionary = {}


func play(delay:float = 0.0, id_override = null, db_override = null, pitch_override = null)->void:
	if delay > 0.0:
		var timer:Timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timers[timer] = [id_override, db_override, pitch_override]
		timer.connect("timeout", self, "_on_play_timer_timeout")
		timer.start(delay)
	else:
		_play(id_override, db_override, pitch_override)


func _on_play_timer_timeout()->void:
	for timer in timers.keys():
		if timer.is_stopped():
			var args:Array = timers[timer]
			call_deferred("callv", "_play", args)
			call_deferred("_remove_timer", timer)


func _remove_timer(timer:Timer)->void:
	if is_a_parent_of(timer):
		timers.erase(timer)
		remove_child(timer)
		timer.queue_free()


func _play(id_override = null, db_override = null, pitch_override = null)->void:
	if !_audio_references.empty():
		var selected_index:int = id_override if id_override != null && id_override is int && id_override >= 0 && id_override < _audio_references.size() else randi() % _audio_references.size()
		audio_stream_player.stream = _audio_references[selected_index]
		audio_stream_player.volume_db = db_override if db_override != null && (db_override is float || db_override is int) else _get_db_volume(selected_index)
		audio_stream_player.pitch_scale = pitch_override if pitch_override != null && (pitch_override is float || pitch_override is int) else _get_pitch_scale(selected_index)
		audio_stream_player.attenuation = _attenuation
		audio_stream_player.bus = _bus
		audio_stream_player.play()


func _get_db_volume(index:int)->float:
	if _db_volumes.size() > index:
		return _db_volumes[index]
	else:
		return 0.0


func _get_pitch_scale(index:int)->float:
	if _pitch_scales.size() > index:
		var pitches:Array = _pitch_scales[index]
		if !pitches.empty():
			return rand_range(pitches[0], pitches[1]) if pitches.size() > 1 else pitches[0]
	return 1.0
