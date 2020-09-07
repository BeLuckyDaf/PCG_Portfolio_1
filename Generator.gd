class_name Generator
extends Node2D


onready var drawer := $Drawer


export var multiplier : int = 10
export var iterations : int = 15
export var size : int = 60
export var death_limit : int = 4
export var birth_limit : int = 1
export var chance_alive : float = 0.5

func _ready():
	make_map()

func make_map():
	var map = generate_map(size, iterations)
	_mirror_map(map)
	map = _simulate(map)
	_mirror_map(map, true)
	map = _simulate(map)
	drawer.set_map(map, multiplier)

func _generate_random_map(size):
	var map = []
	for y in range(size):
		map.append([])
		for x in range(size):
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

func _get_map_point(map, y, x, size):
	if x < 0 or x > size-1 or y < 0 or y > size-1:
		return 1
	return map[y][x]

func _simulate(map):
	var newmap = map.duplicate()
	for y in range(map.size()):
		for x in range(map[y].size()):
			var l = _get_map_point(map, y, x-1, size)
			var r = _get_map_point(map, y, x+1, size)
			var tr = _get_map_point(map, y+1, x+1, size)
			var tl = _get_map_point(map, y+1, x-1, size)
			var br = _get_map_point(map, y-1, x+1, size)
			var bl = _get_map_point(map, y-1, x-1, size)
			var t = _get_map_point(map, y-1, x, size)
			var b = _get_map_point(map, y+1, x, size)
			newmap[y][x] = _apply_rules(map[y][x], l, r, t, b, tr, tl, br, bl)
	return newmap

func generate_map(size, iterations):
	randomize()
	var map = _generate_random_map(size)
	for i in range(iterations):
		map = _simulate(map)
	return map


func _apply_rules(cell, l, r, t, b, tr, tl, br, bl):
	if cell == 1 and l + r + t + b + tr + tl + br + bl <= death_limit:
		cell = 0
	elif cell == 0 and l + r + t + b + tr + tl + br + bl >= birth_limit:
		cell = 1
	return cell
