@tool
extends Node3D
class_name MeshBuilderShape

signal csg_change

enum OPERATION_TYPE {Union, Subtract, Intersect}
@export var operation :OPERATION_TYPE = OPERATION_TYPE.Union

var current_transform :Transform3D
var current_operation :OPERATION_TYPE
var nb_children = 0

func _init(params=[]):
	self.current_transform = transform
	self.current_operation = operation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.get_frames_drawn() % 3 == 0:
		if self.current_transform != transform or self.current_operation != operation or self.nb_children != get_child_count():
			self.current_transform = transform
			self.current_operation = operation
			self.nb_children = get_child_count()
			emit_signal("csg_change")

func get_mesh_builder():
	var parent = self
	while not parent.name == "MeshBuilder":
		parent = parent.get_parent()
	return parent

func get_csg() -> CSG:
	var csg = CSG.new()
	for shape in get_children():
		if not shape is MeshBuilderShape:
			continue
		else:
			match shape.operation:
				MeshBuilderShape.OPERATION_TYPE.Union:
					csg = csg.union(shape.get_csg())
				MeshBuilderShape.OPERATION_TYPE.Subtract:
					csg = csg.subtract(shape.get_csg())
				MeshBuilderShape.OPERATION_TYPE.Intersect:
					csg = csg.intersect(shape.get_csg())
	return csg.scale(scale).rotate(rotation).translate(position)
