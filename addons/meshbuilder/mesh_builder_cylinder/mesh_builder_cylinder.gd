@tool
extends MeshBuilderShape
class_name MeshBuilderCylinder

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.cylinder()

func change_transform():
	csg = CSG.cylinder().scale(scale).rotate(rotation).translate(position)
	super.change_transform()
