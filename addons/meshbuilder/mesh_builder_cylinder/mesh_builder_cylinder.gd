@tool
extends MeshBuilderShape
class_name MeshBuilderCylinder

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.cylinder()

func change_transform():
	csg = CSG.cylinder(transform.origin + Vector3(0,-1,0), transform.origin + Vector3(0,1,0))
	super.change_transform()
