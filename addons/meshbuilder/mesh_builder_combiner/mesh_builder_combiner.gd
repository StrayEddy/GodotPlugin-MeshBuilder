@tool
extends MeshBuilderShape
class_name MeshBuilderCombiner
@icon("res://addons/meshbuilder/mesh_builder_combiner/icon.svg")

var current_values = []

func _init(params=[0]):
	self.operation = params[0]
	super._init(params)
