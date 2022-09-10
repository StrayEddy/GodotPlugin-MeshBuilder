@tool
extends MeshBuilderShape
class_name MeshBuilderCube
@icon("res://addons/meshbuilder/mesh_builder_cube/icon.svg")

var current_values = []

func _init(params=[0]):
	self.operation = params[0]
	super._init(params)

func get_csg():
	return CSG.cube().scale(scale).rotate(rotation).translate(position)
