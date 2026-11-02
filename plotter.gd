extends Control

var x
var y

var x_scale = 1
var y_scale = -5.0
var y_offset = 0.0

func _ready():
	#x = [0 ,1  ,2 ,3 ,4,5 ,6,7,8]
	#y = [-5, -5, 0, 5,0,-5,0,0,5]
	#x_scale = 10
	#y_scale = 10
	x_scale = size.x/120.0
	y_scale = -size.y/200.0
	y_offset = size.y/2.0
	#plot()

func plot():
	var N = len(x)
	for i in N:
		$Canvas/Line2D.add_point(Vector2(x_scale * x[i], y_offset + y_scale * y[i]))
