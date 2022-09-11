@tool
extends MeshBuilderShape
class_name MeshBuilderCone
@icon("res://addons/meshbuilder/mesh_builder_cone/icon.svg")

@export var height :float = 1.0
@export var radius :float = 1.0
@export var slices :int = 16

func _init(params=[1.0,1.0,16,0]):
	self.height = params[0]
	self.radius = params[1]
	self.slices = params[2]
	self.operation = params[3]
	super._init(params)
	self.current_values = [height, radius, slices]

func update():
	var needs_redraw = super.update()
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_values != [height, radius, slices]:
		self.current_values = [height, radius, slices]
		needs_redraw = true
	
	return needs_redraw

func get_csg():
	return CSG.cone(height, radius, slices).scale(scale).rotate(rotation).translate(position)
