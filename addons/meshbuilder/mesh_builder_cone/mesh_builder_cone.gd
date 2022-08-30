@tool
extends MeshBuilderShape
class_name MeshBuilderCone

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.cone()

func change_transform():
	csg = CSG.cone().scale(scale).rotate(rotation).translate(position)
	super.change_transform()
