class_name QuadTree
extends Reference

var root : QuadTreeNode

func _init(root_bounds : Rect2):
	self.root = QuadTreeNode.new(null, root_bounds)
