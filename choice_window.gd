extends Control

const choiceScene = preload("res://choice.tscn")

signal done(index:int, scroll:int)

var choices = []
var Nchoices = 0

var last_choice = 0
var new = false

@onready var container = $Control/ScrollContainer/VBoxContainer
var choice_labels = []
var active = true

var choice = ""

var last_scroll_vertical = 0.0

var pos = Vector2.ZERO

func _process(_delta: float) -> void:
	if active:
		if Input.is_action_just_pressed("DoStuff"):
			choice = get_viewport().gui_get_focus_owner().index
			pos = get_viewport().gui_get_focus_owner().global_position
			end()
		last_scroll_vertical = $Control/ScrollContainer.scroll_vertical

func _ready() -> void:
	#$Control/ScrollContainer.scroll_vertical = last_scroll_vertical
	$Control/ScrollContainer.set_deferred("scroll_vertical", last_scroll_vertical)
	Nchoices = len(choices)
	for i in Nchoices:
		var tmp = choiceScene.instantiate()
		choice_labels.append(tmp)
		tmp.text = " " + choices[i] + " "
		tmp.index = i
		container.add_child(tmp)
		if i == 0:
			tmp.make_cool()
		if new and i == 1:
			tmp.make_new()
		if i>1:
			tmp.focus_neighbor_top = choice_labels[i-1].get_path()
			choice_labels[i-1].focus_neighbor_bottom = tmp.get_path()
		if i == Nchoices - 1:
			choice_labels[0].focus_neighbor_top = tmp.get_path()
			tmp.focus_neighbor_bottom = choice_labels[0].get_path()
		
		if i == last_choice:
			tmp.grab_focus()

func end():
	done.emit(choice,last_scroll_vertical, pos)
	queue_free()
