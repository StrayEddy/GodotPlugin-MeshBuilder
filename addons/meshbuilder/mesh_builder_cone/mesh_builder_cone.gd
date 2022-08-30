@tool
extends MeshBuilderShape
class_name MeshBuilderCone

@export var height :float = 1.0
@export var radius :float = 1.0
@export var slices :int = 16
var current_values :Array = [height, radius, slices]

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.cone(height, radius, slices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [height, radius, slices]:
		self.current_values = [height, radius, slices]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.cone(height, radius, slices).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
