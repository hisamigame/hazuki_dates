extends Control
class_name Clothes

var base_scale = 0.146

@export var title = ""
@export_multiline var description = ""
@export var image : Texture2D
@export var type = 'head'

@export var score = 0

func _ready() -> void:
	$Front.texture = image
