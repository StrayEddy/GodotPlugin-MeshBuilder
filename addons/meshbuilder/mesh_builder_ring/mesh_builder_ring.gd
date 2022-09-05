@tool
extends MeshBuilderShape
class_name MeshBuilderRing

@export var height :float = 1.0
@export var inner_radius :float = 0.5
@export var outer_radius :float = 1.0
@export var slices :int = 16
var current_values :Array = [height, inner_radius, outer_radius, slices]

func _init(params=[1.0,0.5,1.0,16,0]):
	self.height = params[0]
	self.inner_radius = params[1]
	self.outer_radius = params[2]
	self.slices = params[3]
	self.operation = params[4]
	super._init(params)
	self.current_values = [height, inner_radius, outer_radius, slices]
	csg = CSG.ring(height, inner_radius, outer_radius, slices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [height, inner_radius, outer_radius, slices]:
		self.current_values = [height, inner_radius, outer_radius, slices]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.ring(height, inner_radius, outer_radius, slices).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
