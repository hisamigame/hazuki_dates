extends Node2D

const clothingScene = preload("res://clothing_select.tscn")
const dialogWindowScene = preload("res://dialog_window.tscn")
const resultsWindowScene = preload("res://result_window.tscn")

func show_initial_choice():
	var tmp = clothingScene.instantiate()
	add_child(tmp)
	tmp.activate()
	tmp.done.connect(post_select)

func post_select(success):
	$FG/FadeIn.active =true
	var tmp = dialogWindowScene.instantiate()
	global.fade_bgm()
	if success:
		tmp.texts = ["Glad you could make it.\nNo you're not late, I just came here myself."]
		tmp.done.connect(to_game)
	else:
		tmp.texts = ["...!","I just remembered I have somewhere else I need to be.\nGood bye!"]
		tmp.emotes = ['sad','shock']
		tmp.done.connect(show_results)
	tmp.emotion_change.connect(change_emote)
	add_child(tmp)

func to_game():
	get_tree().change_scene_to_file("res://game_window.tscn")

func change_emote(emote):
	$Hazuki.change_emote(emote)

func show_results():
	$Hazuki.go_away()
	var tmp = resultsWindowScene.instantiate()
	add_child(tmp)
	

func _ready() -> void:
	show_initial_choice()
