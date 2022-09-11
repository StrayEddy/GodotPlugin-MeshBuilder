@tool
extends MeshBuilderShape
class_name MeshBuilderTorus
@icon("res://addons/meshbuilder/mesh_builder_torus/icon.svg")

@export var innerR :float = 0.5
@export var outerR :float = 1.0
@export var stacks :int = 8
@export var slices :int = 6

func _init(params=[0.5,1.0,8,6,0]):
	self.innerR = params[0]
	self.outerR = params[1]
	self.stacks = params[2]
	self.slices = params[3]
	self.operation = params[4]
	super._init(params)
	self.current_values = [innerR, outerR, stacks, slices]

func update():
	var needs_redraw = super.update()
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_values != [innerR, outerR, stacks, slices]:
		self.current_values = [innerR, outerR, stacks, slices]
		needs_redraw = true
	
	return needs_redraw

func get_csg():
	return CSG.torus(innerR, outerR, stacks, slices).scale(scale).rotate(rotation).translate(position)
