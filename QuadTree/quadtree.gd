class_name QuadTree
extends Reference

var root : QuadTreeNode

func _init(root_bounds : Rect2):
	self.root = QuadTreeNode.new(null, root_bounds)

func insert_rect(bounds : Rect2, value : int):
	root.insert_rect(bounds, value)
