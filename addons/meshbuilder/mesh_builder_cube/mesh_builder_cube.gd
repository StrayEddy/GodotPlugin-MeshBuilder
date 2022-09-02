@tool
extends MeshBuilderShape
class_name MeshBuilderCube

var current_values = []

func init(params):
	self.operation = params[0]
	super.init(params)
	csg = CSG.cube()
	return self

func change_transform():
	csg = CSG.cube().scale(scale).rotate(rotation).translate(position)
	super.change_transform()
