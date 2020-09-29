class_name QuadTreeNode
extends Reference

# state only has meaning if it is a leaf
var state : int

var bounds : Rect2

var parent : QuadTreeNode
var child_nw : QuadTreeNode
var child_ne : QuadTreeNode
var child_sw : QuadTreeNode
var child_se : QuadTreeNode

func _init(parent : QuadTreeNode, bounds : Rect2):
	self.bounds = bounds
	self.state = 0
	self.parent = parent

func split():
	child_nw = get_script().new(self, Rect2(Vector2(bounds.position.x, bounds.position.y), bounds.size/2))
	child_ne = get_script().new(self, Rect2(Vector2(bounds.position.x + bounds.size.x/2, bounds.position.y), bounds.size/2))
	child_sw = get_script().new(self, Rect2(Vector2(bounds.position.x, bounds.position.y + bounds.size.y/2), bounds.size/2))
	child_se = get_script().new(self, Rect2(Vector2(bounds.position.x + bounds.size.x/2, bounds.position.y + bounds.size.y/2), bounds.size/2))
	child_nw.state = state
	child_ne.state = state
	child_sw.state = state
	child_se.state = state
	state = -1

func free_children():
	if child_nw != null:
		child_nw = null
	if child_ne != null:
		child_ne = null
	if child_sw != null:
		child_sw = null
	if child_se != null:
		child_se = null

func insert_rect(target : Rect2, value : int):
	target.position.x = round(target.position.x)
	target.position.y = round(target.position.y)
	if target.encloses(bounds):
		state = value
		free_children()
	elif bounds.intersects(target):
		if state != -1:
			split()
		child_nw.insert_rect(target, value)
		child_ne.insert_rect(target, value)
		child_sw.insert_rect(target, value)
		child_se.insert_rect(target, value)
		if child_ne.state != -1 and child_ne.state == child_nw.state and child_ne.state == child_sw.state and child_ne.state == child_se.state:
			state = child_ne.state
			free_children()

func state_at_point(point : Vector2) -> int:
	if state != -1:
		return state
	elif child_nw.bounds.has_point(point):
		return child_nw.state_at_point(point)
	elif child_ne.bounds.has_point(point):
		return child_ne.state_at_point(point)
	elif child_sw.bounds.has_point(point):
		return child_sw.state_at_point(point)
	elif child_se.bounds.has_point(point):
		return child_se.state_at_point(point)
	else:
		#print("No one has the point")
		return -1
