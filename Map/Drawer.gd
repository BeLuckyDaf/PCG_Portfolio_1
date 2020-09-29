class_name Drawer
extends Node2D


var map : Map
var mul = 8
var limit = 2

var tree : QuadTree

onready var block := preload("res://Blocks/Block.tscn")

signal on_map_updated(new_map)
signal on_map_drawn(multiplier)

func fill_node(node: QuadTreeNode):
	var count : int = 0
	for y in node.bounds.size.y:
		for x in node.bounds.size.x:
			var actual_y = y + node.bounds.position.y
			var actual_x = x + node.bounds.position.x
			if map.plain[actual_y * map.width + actual_x] != 0:
				count += 1
	if count > limit and count < (node.bounds.size.y * node.bounds.size.x) - limit: # then split
		node.split()
		fill_node(node.child_nw)
		fill_node(node.child_ne)
		fill_node(node.child_sw)
		fill_node(node.child_se)
		node.state = -1
	elif count < limit:
		node.state = 0
	else:
		node.state = 1

func generate_tree():
	tree = QuadTree.new(Rect2(Vector2.ZERO, Vector2(map.width, map.height)))
	fill_node(tree.root)

func set_map(value, multiplier):
	map = value
	mul = multiplier
	emit_signal("on_map_updated", value)

func _on_Drawer_on_map_updated(new_map):
	generate_tree()
	update()
	#_remove_blocks()
	#_put_blocks()
	emit_signal("on_map_drawn", mul)

func _draw():
	var stack = []
	if tree != null:
		stack.push_back(tree.root)
		while stack.size() > 0:
			var node = stack.pop_back()
			if node.state == -1:
				stack.push_back(node.child_nw)
				stack.push_back(node.child_ne)
				stack.push_back(node.child_sw)
				stack.push_back(node.child_se)
			elif node.state == 1:
				draw_rect(Rect2(node.bounds.position * mul, node.bounds.size * mul), Color.black)
			#draw_rect(Rect2(node.bounds.position * mul, node.bounds.size * mul), Color.crimson, false, 2)

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

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var x = round(rand_range(0, 255))
		var y = round(rand_range(0, 255))
		tree.insert_rect(Rect2(Vector2(x, y), Vector2.ONE*10), 1)
		update()

func _on_Drawer_on_map_drawn(multiplier):
	var sizey = map.height*mul
	if sizey > 0:
		var sizex = map.width*mul
		OS.window_size = Vector2(sizex, sizey)
		OS.center_window()
