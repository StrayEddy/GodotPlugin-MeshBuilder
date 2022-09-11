@tool
extends Node3D
class_name MeshBuilderShape

enum OPERATION_TYPE {Union, Subtract, Intersect}
@export var operation :OPERATION_TYPE = OPERATION_TYPE.Union

var root :Node3D
var current_transform :Transform3D
var current_operation :OPERATION_TYPE
var current_values :Array = []
var nb_children = 0

func _init(params=[]):
	self.current_transform = transform
	self.current_operation = operation

func _ready():
	root = get_tree().get_edited_scene_root()

func update():
	var needs_redraw = false
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_transform != transform or self.current_operation != operation or self.nb_children != get_child_count():
		self.current_transform = transform
		self.current_operation = operation
		self.nb_children = get_child_count()
		needs_redraw = true
	return needs_redraw

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

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": name,
		"operation": operation,
		"scale": [scale.x, scale.y, scale.z],
		"rotation": [rotation.x, rotation.y, rotation.z],
		"position": [position.x, position.y, position.z],
		"params": current_values,
		"children": children
	}
	return json

func add_shape(shape :MeshBuilderShape, name :String):
	if "Combiner" in self.name:
		self.add_child(shape, true)
		shape.name = name
		shape.owner = root
	else:
		# Add combiner to parent
		var combiner = load("res://addons/meshbuilder/mesh_builder_combiner/mesh_builder_combiner.gd").new()
		self.get_parent().add_child(combiner, true)
		combiner.name = "Combiner"
		combiner.owner = root
		# Move selected node under combiner
		reparent(self, combiner)
		combiner.operation = self.operation
		self.operation = MeshBuilderShape.OPERATION_TYPE.Union
		self.owner = root
		# Add shape under combiner
		combiner.add_child(shape, true)
		shape.name = name
		shape.owner = root

static func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func add_combiner():
	var combiner = load("res://addons/meshbuilder/mesh_builder_combiner/mesh_builder_combiner.gd").new()
	combiner.name = "Combiner"
	self.add_child(combiner, true)
	combiner.owner = root
	return combiner
func add_cone(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCone.new()
	else:
		shape = MeshBuilderCone.new(params)
	add_shape(shape, "Cone")
	return shape
func add_double_cone(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderDoubleCone.new()
	else:
		shape = MeshBuilderDoubleCone.new(params)
	add_shape(shape, "DoubleCone")
	return shape
func add_cube(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCube.new()
	else:
		shape = MeshBuilderCube.new(params)
	add_shape(shape, "Cube")
	return shape
func add_cylinder(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCylinder.new()
	else:
		shape = MeshBuilderCylinder.new(params)
	add_shape(shape, "Cylinder")
	return shape
func add_sphere(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderSphere.new()
	else:
		shape = MeshBuilderSphere.new(params)
	add_shape(shape, "Sphere")
	return shape
func add_half_sphere(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderHalfSphere.new()
	else:
		shape = MeshBuilderHalfSphere.new(params)
	add_shape(shape, "HalfSphere")
	return shape
func add_torus(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderTorus.new()
	else:
		shape = MeshBuilderTorus.new(params)
	add_shape(shape, "Torus")
	return shape
func add_ring(params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderRing.new()
	else:
		shape = MeshBuilderRing.new(params)
	add_shape(shape, "Ring")
	return shape
