@tool
extends MeshBuilderShape
class_name MeshBuilderRing
@icon("res://addons/meshbuilder/mesh_builder_ring/icon.svg")

@export var height :float = 1.0
@export var inner_radius :float = 0.5
@export var outer_radius :float = 1.0
@export var slices :int = 16

func _init(params=[1.0,0.5,1.0,16,0]):
	self.height = params[0]
	self.inner_radius = params[1]
	self.outer_radius = params[2]
	self.slices = params[3]
	self.operation = params[4]
	super._init(params)
	self.current_values = [height, inner_radius, outer_radius, slices]

func update():
	var needs_redraw = super.update()
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_values != [height, inner_radius, outer_radius, slices]:
		self.current_values = [height, inner_radius, outer_radius, slices]
		needs_redraw = true
	
	return needs_redraw

func get_csg():
	return CSG.ring(height, inner_radius, outer_radius, slices).scale(scale).rotate(rotation).translate(position)
