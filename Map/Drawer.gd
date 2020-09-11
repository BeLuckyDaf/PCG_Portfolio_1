class_name Drawer
extends Node2D


var map : Map
var mul = 8

onready var block := preload("res://Blocks/Block.tscn")

signal on_map_updated(new_map)
signal on_map_drawn(multiplier)

func _ready():
	OS.window_resizable = false

func set_map(value, multiplier):
	map = value
	mul = multiplier
	emit_signal("on_map_updated", value)

func _on_Drawer_on_map_updated(new_map):
	update()
	_remove_blocks()
	_put_blocks()
	emit_signal("on_map_drawn", mul)

func _remove_blocks():
	for child in get_children():
		child.queue_free()

func _put_blocks():
	var map_node = self # get_tree().root.get_node_or_null("Map")
	if map_node == null:
		map_node = Node2D.new()
		map_node.name = "Map"
		get_tree().root.call_deferred("add_child", map_node)
	else:
		for child in map_node.get_children():
			child.call_deferred("queue_free")
	for y in range(map.height):
		for x in range(map.width):
			if map.plain[y * map.width + x] == 1:
				var instance = block.instance()
				instance.size = Vector2(mul, mul)
				instance.position = Vector2(mul/2, mul/2) + Vector2(x, y)*mul
				map_node.add_child(instance)


func _on_Drawer_on_map_drawn(multiplier):
	var sizey = map.height*mul
	if sizey > 0:
		var sizex = map.width*mul
		OS.window_size = Vector2(sizex, sizey)
		OS.center_window()
