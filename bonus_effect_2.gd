extends Node2D

@export_multiline var text = ""
@export var size = 48

var time = 0.3
var lifetime = 2.0
var t = 0.0
var do_play

func _ready() -> void:
	var t2
	var tmp = text.split('\n')
	t2 = tmp[1]
	match tmp[1]:
		"video_games":
			t2 = "Video Games"
		"culture":
			t2 = 'Humanities'
		'rock':
			t2 = "Rock Music"
		'jazz':
			t2 = "Jazz Music"
		'classic':
			t2 = "Classical Music"
		'stem':
			t2 = "STEM"
	text = tmp[0] + '\n' + t2
	$Label.text = text
	$Label2.text = text
	$Label.add_theme_font_size_override("font_size",size)
	$Label2.add_theme_font_size_override("font_size",size)
	#$Label2.add_theme_constant_override("outline_size",2)
	play()
	
func play():
	if not do_play:
		scale = Vector2.ZERO
		modulate.a = 1.0
		visible = true
		do_play = true
	
func _process(delta: float) -> void:
	if do_play:
		t = t + delta
		if t <= time:
			scale = Vector2.ONE * (1*t/time)
		if t > lifetime/2.0:
			modulate.a = 1-2.0 * (t-lifetime/2.0)/lifetime
			material.set_shader_parameter('alpha_mult',modulate.a)
		if t > lifetime:
			queue_free()
