@tool
extends MeshBuilderShape
class_name MeshBuilderSphere

@export var slices :int = 12
@export var stacks :int = 6
var current_values :Array = [slices, stacks]

# Called when the node enters the scene tree for the first time.
func _ready():
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
