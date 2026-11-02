extends TextureRect


var switch = false
var delay_time = 0.01
var delay_t = 0.0

func _ready() -> void:
	global.stop_bgm()
	global.play_bgm2()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DoStuff") and delay_t > delay_time:
		switch = true
	
func _process(delta: float) -> void:
	delay_t = delay_t + delta
	if switch and delay_t > delay_time:
		get_tree().change_scene_to_file("res://pregame_window.tscn")
		switch = false
