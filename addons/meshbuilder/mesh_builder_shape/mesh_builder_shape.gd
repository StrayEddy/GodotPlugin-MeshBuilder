@tool
extends Node3D
class_name MeshBuilderShape

signal csg_change

enum OPERATION_TYPE {Union, Subtract, Intersect}
@export var operation :OPERATION_TYPE = OPERATION_TYPE.Union
var csg :CSG

var current_transform :Transform3D
var current_operation :OPERATION_TYPE

func _init(params=[]):
	self.current_transform = transform
	self.current_operation = operation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_transform != transform or self.current_operation != operation:
		self.current_transform = transform
		self.current_operation = operation
		change_transform()
		emit_signal("csg_change")

# Exist only to be overriden by all shapes
func change_transform():
	pass

func get_mesh_builder():
	var parent = self
	while not parent is MeshBuilder:
		parent = parent.get_parent()
	return parent
	
