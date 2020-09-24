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
