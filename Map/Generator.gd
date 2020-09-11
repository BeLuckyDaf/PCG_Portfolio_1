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
	var st = OS.get_ticks_msec()
	var arenagen = ArenaGenerator.new()
	arenagen.set_thresholds(5, 3)
	var map := Map.new()
	map.plain = arenagen.generate(map_width, map_height, iterations, chance_alive * 100, after_mirror_sims)
	map.width = map_width
	map.height = map_height
	print("Map generated for %.3fs" % ((OS.get_ticks_msec() - st) / 1000.0))
	
	st = OS.get_ticks_msec()
	drawer.set_map(map, multiplier)
	print("Drawing complete for %.3fs" % ((OS.get_ticks_msec() - st) / 1000.0))
