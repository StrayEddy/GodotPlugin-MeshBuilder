@tool
extends MeshBuilderShape
class_name MeshBuilderCone

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.cone()

func change_transform():
	csg = CSG.cone(transform.origin + Vector3(0,-1,0), transform.origin + Vector3(0,1,0))
	super.change_transform()
