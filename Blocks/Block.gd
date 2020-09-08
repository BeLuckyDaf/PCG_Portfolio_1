class_name Block
extends StaticBody2D

onready var explosion = preload("res://Particles/Explosion.tscn")

export var size : Vector2 = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Destroyable")

func _draw():
	draw_rect(Rect2(-size/2, size), Color.black)
	
func destroy():
	var instance = explosion.instance()
	instance.position = position
	get_parent().add_child(instance)
	queue_free()
