@tool
extends MeshBuilderShape
class_name MeshBuilderDoubleCone
@icon("res://addons/meshbuilder/mesh_builder_double_cone/icon.svg")

@export var height :float = 2.0
@export var radius :float = 1.0
@export var slices :int = 16
var current_values :Array = [height, radius, slices]

func _init(params=[2.0,1.0,16,0]):
	self.height = params[0]
	self.radius = params[1]
	self.slices = params[2]
	self.operation = params[3]
	super._init(params)
	self.current_values = [height, radius, slices]
	csg = CSG.double_cone(height, radius, slices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [height, radius, slices]:
		self.current_values = [height, radius, slices]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.double_cone(height, radius, slices).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
