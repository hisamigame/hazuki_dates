extends Control


signal done
signal emotion_change(String)

var texts = [] # array of strings
var emotes = [] # array of expressions, same lenght as texts or empty
var Ntexts = 0
var Nemotes = 0
var color = Color("f3a355")
var speaker = "Hazuki"

var itext = 0
var active_text = ""
var maxchar = 0
var t = 0.0
var revealing = true
var active = true

var emotion_changes = true
var text_show_progress = 0.0
var characters_per_second = 10.0


@onready var label = $ColorRect/Label
@onready var name_label = $ColorRect2/Label

func _ready() -> void:
	if len(speaker) > 0:
		name_label.text  = speaker
	else:
		$ColorRect2.visible = false
	
	label.add_theme_color_override("font_color", color)
	Ntexts = len(texts)
	Nemotes = len(emotes)
	if Nemotes > 0:
		emotion_changes = true
		assert(Nemotes == Ntexts)
	else:
		emotion_changes = false
		emotion_change.emit('neutral')
		
	show_text(itext)

func show_text(i):
	revealing = true
	t = 0.0
	text_show_progress = 0.0
	label.visible_characters = 0 
	active_text = texts[i]
	maxchar = len(active_text)
	label.text = active_text
	if emotion_changes:
		emotion_change.emit(emotes[i])
	
func _process(delta: float) -> void:
	if active:
		if revealing:
			t = t + delta
			label.visible_characters = t*characters_per_second
		if Input.is_action_just_pressed("DoStuff"):
			do_stuff()
		if label.visible_characters == maxchar:
			revealing = false
	
func end():
	done.emit()
	active = false
	#queue_free()
	
func do_stuff():
	if label.visible_characters < maxchar:
		label.visible_characters = maxchar
	elif itext == Ntexts -1:
		end()
	else:
		itext = itext +  1
		show_text(itext)
