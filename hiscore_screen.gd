extends TextureRect

enum {NORMAL, INPUT}
var state = NORMAL
var nletter = 0

@onready var vsplit = $CenterContainer/MarginContainer/MarginContainer/CenterContainer/VSplitContainer

var placement:  int

var scores =[]
var names =[]
var entries = []

var start_letter = 0
var current_letter = 0
var nameinput = 'A  '

const characterset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const nchars = 23

func get_scores_and_names():
	for hs in global.hiscores:
		scores.append(hs[0])
		names.append(hs[1])

func find_score_placement(score):
	var ret = scores.find_custom(func (x): return score > x)
	return ret

func to_input1():
	state = INPUT
	placement = find_score_placement(global.score)
	scores.insert(placement,global.score)
	names.insert(placement,nameinput)
	scores.pop_back()
	names.pop_back()

func setup():
	var i = 0
	for c in vsplit.get_children():
		if c is HiScoreEntry:
			c.set_AAA(names[i])
			c.set_score(scores[i])
			entries.append(c)
			i = i +1

func shift_entries_below_index(array, index):
	for i in range(len(array)-1,index,-1):
		array[i] = array[i-1]

func _ready() -> void:
	get_scores_and_names()
	# can override scores here for testing
	#global.score = 1000001
	if global.score > scores[-1]:
		to_input1()
		setup()
		shift_entries_below_index(entries,placement)
		entries[placement].turn_yellow()
	else:
		state = NORMAL
		setup()
	

func process_name_input(event: InputEvent):
	if event.is_action_pressed("DoStuff") or event.is_action_pressed("ui_right"):
		nameinput[nletter] = characterset[current_letter]
		nletter = nletter + 1
		#current_letter = start_letter
		if nletter > 2:
			state = NORMAL
			entries[placement].turn_normal()
			#global.play_coin()
			shift_entries_below_index(global.hiscores,placement)
			global.hiscores[placement] = [global.score, nameinput]
			return 
	elif event.is_action_pressed("ui_left"):
		nameinput[nletter]=' '
		nletter = nletter - 1
		if nletter < 0:
			nletter = 0
		current_letter = characterset.find(nameinput[nletter])
	elif event.is_action_pressed("ui_up"):
		current_letter = (current_letter + 1)%nchars
	elif event.is_action_pressed("ui_down"):
		current_letter = (current_letter - 1)%nchars
	nameinput[nletter] = characterset[current_letter]
	entries[placement].set_AAA(nameinput)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo():
		match state:
			NORMAL:
				if event.is_action_pressed("DoStuff"):
					global.save_data()
					get_tree().change_scene_to_file("res://title_screen.tscn")
			INPUT:
				process_name_input(event)
