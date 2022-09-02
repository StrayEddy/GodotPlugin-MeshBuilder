@tool
extends Node3D
class_name MeshBuilderShape

signal csg_change

enum OPERATION_TYPE {Union, Subtract, Intersect}
@export var operation :OPERATION_TYPE = OPERATION_TYPE.Union
var csg :CSG

var current_transform :Transform3D
var current_operation :OPERATION_TYPE

func init(params):
	self.current_transform = transform
	self.current_operation = operation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_transform != transform:
		self.current_transform = transform
		change_transform()
		emit_signal("csg_change")
	if self.current_operation != operation:
		self.current_operation = operation
		emit_signal("csg_change")

# Exist only to be overriden by all shapes
func change_transform():
	pass
