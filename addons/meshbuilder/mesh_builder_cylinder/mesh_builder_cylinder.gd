@tool
extends MeshBuilderShape
class_name MeshBuilderCylinder

@export var height :float = 1.0
@export var bottom_radius :float = 1.0
@export var top_radius :float = 1.0
@export var slices :int = 16
var current_values :Array = [height, bottom_radius, top_radius, slices]

func _init(params=[1.0,1.0,1.0,16,0]):
	self.height = params[0]
	self.bottom_radius = params[1]
	self.top_radius = params[2]
	self.slices = params[3]
	self.operation = params[4]
	super._init(params)
	self.current_values = [height, bottom_radius, top_radius, slices]
	csg = CSG.cylinder(height, bottom_radius, top_radius, slices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [height, bottom_radius, top_radius, slices]:
		self.current_values = [height, bottom_radius, top_radius, slices]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.cylinder(height, bottom_radius, top_radius, slices).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
