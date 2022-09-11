@tool
extends MeshBuilderShape
class_name MeshBuilderCylinder
@icon("res://addons/meshbuilder/mesh_builder_cylinder/icon.svg")

@export var height :float = 1.0
@export var bottom_radius :float = 1.0
@export var top_radius :float = 1.0
@export var slices :int = 16

func _init(params=[1.0,1.0,1.0,16,0]):
	self.height = params[0]
	self.bottom_radius = params[1]
	self.top_radius = params[2]
	self.slices = params[3]
	self.operation = params[4]
	super._init(params)
	self.current_values = [height, bottom_radius, top_radius, slices]

func update():
	var needs_redraw = super.update()
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_values != [height, bottom_radius, top_radius, slices]:
		self.current_values = [height, bottom_radius, top_radius, slices]
		needs_redraw = true
	
	return needs_redraw

func get_csg():
	return CSG.cylinder(height, bottom_radius, top_radius, slices).scale(scale).rotate(rotation).translate(position)
