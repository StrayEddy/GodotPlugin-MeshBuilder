@tool
extends MeshBuilderShape
class_name MeshBuilderHalfSphere
@icon("res://addons/meshbuilder/mesh_builder_half_sphere/icon.svg")

@export var slices :int = 12
@export var stacks :int = 3
var current_values :Array = [slices, stacks]

func _init(params=[12,3,0]):
	self.slices = params[0]
	self.stacks = params[1]
	self.operation = params[2]
	super._init(params)
	self.current_values = [slices, stacks]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [slices, stacks]:
		self.current_values = [slices, stacks]
		emit_signal("csg_change")
	super._process(delta)

func get_csg():
	return CSG.half_sphere(slices, stacks).scale(scale).rotate(rotation).translate(position)
