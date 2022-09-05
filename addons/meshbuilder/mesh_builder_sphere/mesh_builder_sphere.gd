@tool
extends MeshBuilderShape
class_name MeshBuilderSphere

@export var slices :int = 12
@export var stacks :int = 6
var current_values :Array = [slices, stacks]

func _init(params=[12,6,0]):
	self.slices = params[0]
	self.stacks = params[1]
	self.operation = params[2]
	super._init(params)
	self.current_values = [slices, stacks]
	csg = CSG.sphere(slices, stacks)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [slices, stacks]:
		self.current_values = [slices, stacks]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.sphere(slices, stacks).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
