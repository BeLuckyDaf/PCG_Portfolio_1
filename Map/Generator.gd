class_name Generator
extends Node2D

onready var drawer := $Drawer

export var multiplier : int = 8
export var iterations : int = 15
export var map_width : int = 240
export var map_height : int = 120
export var death_limit : int = 3
export var birth_limit : int = 5
export var chance_alive : float = 0.45
export var after_mirror_sims : int = 2

func _ready():
	make_map()

func make_map():
	var map = generate_map(map_width, map_height, iterations)
	_mirror_map(map)
	_simulate_times(map, after_mirror_sims)
	_mirror_map(map, true)
	_simulate_times(map, after_mirror_sims)
	drawer.set_map(map, multiplier)

func _generate_random_map(w, h):
	var map = []
	for y in range(h):
		map.append([])
# warning-ignore:unused_variable
		for x in range(w):
			map[y].append(1 if rand_range(0, 1) < chance_alive else 0)
	return map

func _mirror_map(map, vertical=false):
	if vertical:
		for y in range(int(map.size()/2)):
			for x in range(int(map[y].size())):
				map[map.size()-y-1][x] = map[y][x]
	else:
		for y in range(map.size()):
			for x in range(int(map[y].size()/2)):
				map[y][map[y].size()-x-1] = map[y][x]

func _get_map_point(map, y, x, w, h):
	if x < 0 or x > w-1 or y < 0 or y > h-1:
		return 1
	return map[y][x]

func _simulate_times(map, n):
	for i in range(n):
		map = _simulate(map)

func _simulate(map):
	var newmap = map.duplicate()
	for y in range(map.size()):
		for x in range(map[y].size()):
			var l = _get_map_point(map, y, x-1, map_width, map_height)
			var r = _get_map_point(map, y, x+1, map_width, map_height)
			var tr = _get_map_point(map, y+1, x+1, map_width, map_height)
			var tl = _get_map_point(map, y+1, x-1, map_width, map_height)
			var br = _get_map_point(map, y-1, x+1, map_width, map_height)
			var bl = _get_map_point(map, y-1, x-1, map_width, map_height)
			var t = _get_map_point(map, y-1, x, map_width, map_height)
			var b = _get_map_point(map, y+1, x, map_width, map_height)
			newmap[y][x] = _apply_rules(map[y][x], l, r, t, b, tr, tl, br, bl)
	return newmap

func generate_map(w, h, n):
	randomize()
	var map = _generate_random_map(w, h)
# warning-ignore:unused_variable
	for i in range(n):
		map = _simulate(map)
	return map


func _apply_rules(cell, l, r, t, b, tr, tl, br, bl):
	if cell == 1 and l + r + t + b + tr + tl + br + bl <= death_limit:
		cell = 0
	elif cell == 0 and l + r + t + b + tr + tl + br + bl >= birth_limit:
		cell = 1
	return cell
