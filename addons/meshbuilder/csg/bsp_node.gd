@tool
extends Node
class_name BSPNode
# class BSPNode
# Holds a node in a BSP tree. A BSP tree is built from a collection of polygons
# by picking a polygon to split along. That polygon (and all other coplanar
# polygons) are added directly to that node and the other polygons are added to
# the front and/or back subtrees. This is not a leafy BSP tree since there is
# no distinction between internal and leaf nodes.

var plane
var front
var back
var polygons = []

func _init(polygons=null):
	self.plane = null # Plane instance
	self.front = null # BSPNode
	self.back = null  # BSPNode
	self.polygons = []
	if polygons:
		self.build(polygons)

func clone():
	var node = BSPNode.new()
	if self.plane: 
		node.plane = self.plane.clone()
	if self.front: 
		node.front = self.front.clone()
	if self.back: 
		node.back = self.back.clone()
	
	var polygons_clone = []
	for poly in self.polygons:
		polygons_clone.append(poly.clone())
	node.polygons = polygons_clone
	return node

# Convert solid space to empty space and empty space to solid space.
func invert():
	for poly in self.polygons:
		poly.flip()
	if self.plane:
		self.plane.flip()
	if self.front: 
		self.front.invert()
	if self.back: 
		self.back.invert()
	var temp = self.front
	self.front = self.back
	self.back = temp

# Recursively remove all polygons in `polygons` that are inside this BSP
# tree.
func clip_polygons(polygons):
	if self.plane == null:
		var copy = []
		for poly in polygons:
			copy.append(poly.clone())
		return copy

	var front = []
	var back = []
	for poly in polygons:
		self.plane.split_polygon(poly, front, back, front, back)

	if self.front: 
		front = self.front.clip_polygons(front)

	if self.back: 
		back = self.back.clip_polygons(back)
	else:
		back = []

	front.append_array(back)
	return front

# Remove all polygons in this BSP tree that are inside the other BSP tree
# `bsp`.
func clip_to(bsp):
	self.polygons = bsp.clip_polygons(self.polygons)
	if self.front: 
		self.front.clip_to(bsp)
	if self.back: 
		self.back.clip_to(bsp)

# Return a list of all polygons in this BSP tree.
func all_polygons():
	var polygons = []
	for poly in self.polygons:
		polygons.append(poly.clone())
	if self.front: 
		polygons.append_array(self.front.all_polygons())
	if self.back: 
		polygons.append_array(self.back.all_polygons())
	return polygons

# Build a BSP tree out of `polygons`. When called on an existing tree, the
# new polygons are filtered down to the bottom of the tree and become new
# nodes there. Each set of polygons is partitioned using the first polygon
# (no heuristic is used to pick a good split).
func build(polygons):
	if len(polygons) == 0:
		return
	if self.plane == null: 
		self.plane = polygons[0].plane.clone()
	# add polygon to this node
	self.polygons.append(polygons[0])
	var front = []
	var back = []
	# split all other polygons using the first polygon's plane
	for poly in polygons.slice(1):
		# coplanar front and back polygons go into self.polygons
		self.plane.split_polygon(poly, self.polygons, self.polygons,
								front, back)
	# recursively build the BSP tree
	if len(front) > 0:
		if self.front == null:
			self.front = BSPNode.new()
		self.front.build(front)
	if len(back) > 0:
		if self.back == null:
			self.back = BSPNode.new()
		self.back.build(back)
