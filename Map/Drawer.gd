class_name Drawer
extends Node2D

var map : Map
var mul = 8
var limit = 2

var tree : QuadTree

var debug_draw_tree : bool = false
var debug_mouse_draw : int = 0

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
		fill_node(node.get_nw())
		fill_node(node.get_ne())
		fill_node(node.get_sw())
		fill_node(node.get_se())
	elif count < limit:
		node.state = 0
	else:
		node.state = 1

func generate_tree():
	tree = QuadTree.new()
	tree.init_tree(Rect2(Vector2.ZERO, Vector2(map.width, map.height)))
	fill_node(tree.root)

func set_map(value, multiplier):
	map = value
	mul = multiplier
	emit_signal("on_map_updated", value)

func _on_Drawer_on_map_updated(new_map):
	generate_tree()
	update()
	emit_signal("on_map_drawn", mul)

func _draw():
	var stack = []
	if tree != null:
		stack.push_back(tree.root)
		while stack.size() > 0:
			var node = stack.pop_back()
			var bounds = node.bounds
			if node.state == -1:
				stack.push_back(node.get_nw())
				stack.push_back(node.get_ne())
				stack.push_back(node.get_sw())
				stack.push_back(node.get_se())
			elif node.state == 1:
				draw_rect(Rect2(bounds.position * mul, bounds.size * mul), Color.black)
			if debug_draw_tree:
				draw_rect(Rect2(bounds.position * mul, bounds.size * mul), Color.crimson, false, 2)

func draw_explosion_rect(point : Vector2, size : int):
	var rect_size = Vector2(size, size)
	var pos = (point / mul) - (rect_size / 2)
	tree.insert_rect(Rect2(pos, rect_size), 0)
	update()
	
func draw_explosion_circle(point : Vector2):
	var rect_size = Vector2(5, 5)
	var pos = (point / mul) - (rect_size / 2)
	tree.insert_rect(Rect2(pos + Vector2(0, 2), Vector2(5, 1)), 0)
	tree.insert_rect(Rect2(pos + Vector2(2, 0), Vector2(1, 5)), 0)
	tree.insert_rect(Rect2(pos + Vector2(1, 1), Vector2(3, 3)), 0)
	update()

func is_point_blocked(point : Vector2) -> bool:
	return tree.state_at_point(point/mul) == 1

func _input(event):
	if event.is_action_pressed("ui_select"):
		debug_draw_tree = not debug_draw_tree
		update()
	elif event.is_action_pressed("click"):
		debug_mouse_draw = 1
	elif event.is_action_released("click") or event.is_action_released("right_click"):
		debug_mouse_draw = 0
	elif event.is_action_pressed("right_click"):
		debug_mouse_draw = 2

func _process(delta):
	if debug_mouse_draw == 1:
		tree.insert_rect(Rect2((get_global_mouse_position()/mul)-Vector2.ONE * 8, Vector2.ONE * 16), 1)
		update()
	elif debug_mouse_draw == 2:
		tree.insert_rect(Rect2((get_global_mouse_position()/mul)-Vector2.ONE * 8, Vector2.ONE * 16), 0)
		update()

func _on_Drawer_on_map_drawn(multiplier):
	var sizey = map.height*mul
	if sizey > 0:
		var sizex = map.width*mul
		OS.window_size = Vector2(sizex, sizey)
		OS.center_window()
