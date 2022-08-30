@tool
extends MeshBuilderShape
class_name MeshBuilderSphere

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.sphere()

func change_transform():
	csg = CSG.sphere().scale(scale).rotate(rotation).translate(position)
	super.change_transform()
