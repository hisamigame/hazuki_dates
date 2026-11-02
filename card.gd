extends Control
class_name Card

var tween
var flipdur = 0.25
var flipped = false

const ethics = preload("res://card_ethics.png")
const stem = preload("res://card_stem.png")
const athletics = preload("res://card_athletics.png")
const culture = preload("res://card_culture.png")
const medicine = preload("res://card_medicine.png")
const fashion = preload("res://card_fashion.png")
const video_games = preload("res://card_video_games.png")

const rock = preload("res://card_rock.png")
const jazz = preload("res://card_jazz.png")
const classic = preload("res://card_classic.png")
const garderning = preload("res://card_gardening.png")
const painting = preload("res://card_painting.png")

var type : String

var base_scale = 0.146


func set_type(t):
	type = t
	match type:
		"ethics":
			$Front.texture = ethics
		"medicine":
			$Front.texture = medicine
		"culture":
			$Front.texture = culture
		"athletics":
			$Front.texture = athletics
		"video_games":
			$Front.texture = video_games
		"fashion":
			$Front.texture = fashion
		"stem":
			$Front.texture = stem
		"gardening":
			$Front.texture = garderning
		"painting":
			$Front.texture = painting
		"rock":
			$Front.texture = rock
		"jazz":
			$Front.texture = jazz
		"classic":
			$Front.texture = classic

func revert():
	if flipped:
		unflip()

func flip():
	flipped = true
	tween = self.create_tween()
	$Front.scale.x=0.0
	tween.tween_property($Back,"scale:x",0.0,flipdur/2.0)
	tween.tween_property($Front,"scale:x",base_scale,flipdur/2.0)

func unflip():
	flipped = false
	tween = self.create_tween()
	$Back.scale.x=0.0
	tween.tween_property($Front,"scale:x",0.0,flipdur/2.0)
	tween.tween_property($Back,"scale:x",base_scale,flipdur/2.0)


func _on_focus_entered() -> void:
	modulate = Color(0.49, 0.001, 0.588, 1.0)


func _on_focus_exited() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0)
