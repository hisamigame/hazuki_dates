extends Control

signal win(String)
const bonusScene = preload('res://bonus_effect2.tscn')

var last_focused = null
@onready var container = $GridContainer
var cards = []

var numflipped = 0
var flipped_array = []

var active = false
var types = []

var always_types = []
var common_types = []
var rare_types = []

var t = 0.0
var time = 0.4
var end_time = 0.8
var spawn_win_time = 0.4
var win_spawned = false
var do_end = false
var do_unflip = false


func _ready() -> void:
	for c in container.get_children():
		if c is Card:
			cards.append(c)
			c.focus_entered.connect(update_focus)
			last_focused = c
	$GridContainer/Shuffler.shuffle.connect(shuffle)
	$GridContainer/Shuffler.focus_entered.connect(update_focus)
	#activate()

func shuffle():
	cards.shuffle()
	var this_types = always_types + common_types + common_types  + [rare_types.pick_random()]
	#always_types + [always_types.pick_random()] + [rare_types.pick_random()]
	for i in 9:
		cards[2*i].set_type(this_types[i])
		cards[2*i+1].set_type(this_types[i])
		cards[2*i].unflip()
		cards[2*i+1].unflip()
	flipped_array = []
	numflipped = 0
	

func end(type):
	win.emit(type)
	flipped_array = []
	numflipped = 0
	deactivate()
	
func unflip():
	for c in flipped_array:
		c.unflip()
	flipped_array = []
	numflipped = 0

func _process(delta: float) -> void:
	if active:
		if do_unflip:
			t = t + delta
			if t > time:
				t = 0.0
				do_unflip = false
				unflip()
		elif do_end:
			t = t + delta
			if not win_spawned and t > spawn_win_time:
				win_spawned = true
				var tmp = bonusScene.instantiate()
				tmp.text = "NEW DIALOGUE OPTION UNLOCKED:\n" + flipped_array[0].type
				tmp.position = Vector2(512,612)
				add_sibling(tmp)
			if t > end_time:
				t = 0.0
				do_end = false
				end(flipped_array[0].type)
		elif Input.is_action_just_pressed("DoStuff"):
			if last_focused is Card:
				if not last_focused.flipped:
					global.play_flip()
					flipped_array.append(last_focused)
					numflipped = numflipped + 1
					last_focused.flip()
					if numflipped == 2:
						if flipped_array[0].type == flipped_array[1].type:
							do_end = true
						else:
							do_unflip = true
			else:
				global.play_flip()
				last_focused.do_stuff()
				
		

func activate():
	visible = true
	last_focused.grab_focus()
	active = true
	win_spawned = false
	
func deactivate():
	visible = false
	active = false
	
func update_focus():
	last_focused = get_viewport().gui_get_focus_owner()
