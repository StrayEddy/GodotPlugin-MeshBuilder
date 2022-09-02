@tool
extends MeshBuilderShape
class_name MeshBuilderHalfSphere

@export var slices :int = 12
@export var stacks :int = 3
var current_values :Array = [slices, stacks]

func init(params):
	self.slices = params[0]
	self.stacks = params[1]
	self.operation = params[2]
	super.init(params)
	self.current_values = [slices, stacks]
	csg = CSG.half_sphere(slices, stacks)
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [slices, stacks]:
		self.current_values = [slices, stacks]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.half_sphere(slices, stacks).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
