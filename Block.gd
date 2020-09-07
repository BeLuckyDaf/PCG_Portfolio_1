extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var size : Vector2 = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_rect(Rect2(-size/2, size), Color.black)

func _process(delta):
	update()
