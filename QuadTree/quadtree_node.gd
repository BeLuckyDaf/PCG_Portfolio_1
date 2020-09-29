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

func overlaps(target : Rect2) -> bool:
	if target.position.x >= bounds.position.x + bounds.size.x or bounds.position.x >= target.position.x + target.size.x:
		return false
	
	if target.position.y >= bounds.position.y + bounds.size.y or bounds.position.y >= target.position.y + target.size.y:
		return false
		
	return true

func includes(target : Rect2) -> bool:
	if target.position.x > bounds.position.x + bounds.size.x or target.position.x + target.size.x > bounds.position.x + bounds.size.x:
		return false
		
	if target.position.y > bounds.position.y + bounds.size.y or target.position.y + target.size.y > bounds.position.y + bounds.size.y:
		return false
	
	return true

func inside(target : Rect2) -> bool:
	if bounds.position.x >= target.position.x and bounds.position.x <= target.position.x + target.size.x:
		if bounds.position.x + bounds.size.x <= target.position.x + target.size.x:
			if bounds.position.y >= target.position.y and bounds.position.y <= target.position.y + target.size.x:
				if bounds.position.y + bounds.size.y <= target.position.y + target.size.y:
					return true
	return false

func insert_rect(target : Rect2, value : int):
	if inside(target):
		state = value
		free_children()
	elif overlaps(target):
		if state != -1:
			split()
		child_nw.insert_rect(target, value)
		child_ne.insert_rect(target, value)
		child_sw.insert_rect(target, value)
		child_se.insert_rect(target, value)
		if child_ne.state != -1 and child_ne.state == child_nw.state and child_ne.state == child_sw.state and child_ne.state == child_se.state:
			state = child_ne.state
			free_children()
