@tool
extends MeshBuilderShape
class_name MeshBuilderCube

var current_values = []

func _init(params=[0]):
	self.operation = params[0]
	super._init(params)
	csg = CSG.cube()

func change_transform():
	csg = CSG.cube().scale(scale).rotate(rotation).translate(position)
	super.change_transform()
