@tool
extends MeshBuilderShape
class_name MeshBuilderDoubleCone

@export var height :float = 2.0
@export var radius :float = 1.0
@export var slices :int = 16
var current_values :Array = [height, radius, slices]

func init(params):
	self.height = params[0]
	self.radius = params[1]
	self.slices = params[2]
	self.operation = params[3]
	super.init(params)
	self.current_values = [height, radius, slices]
	csg = CSG.double_cone(height, radius, slices)
	return self

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
