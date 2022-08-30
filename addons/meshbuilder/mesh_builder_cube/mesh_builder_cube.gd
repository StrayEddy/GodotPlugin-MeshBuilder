@tool
extends MeshBuilderShape
class_name MeshBuilderCube

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.cube()

func change_transform():
	csg = CSG.cube().scale(scale).rotate(rotation).translate(position)
	super.change_transform()
