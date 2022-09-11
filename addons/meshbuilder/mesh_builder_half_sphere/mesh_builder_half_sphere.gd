@tool
extends MeshBuilderShape
class_name MeshBuilderHalfSphere
@icon("res://addons/meshbuilder/mesh_builder_half_sphere/icon.svg")

@export var slices :int = 12
@export var stacks :int = 3

func _init(params=[12,3,0]):
	self.slices = params[0]
	self.stacks = params[1]
	self.operation = params[2]
	super._init(params)
	self.current_values = [slices, stacks]

func update():
	var needs_redraw = super.update()
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_values != [slices, stacks]:
		self.current_values = [slices, stacks]
		needs_redraw = true
	
	return needs_redraw

func get_csg():
	return CSG.half_sphere(slices, stacks).scale(scale).rotate(rotation).translate(position)
