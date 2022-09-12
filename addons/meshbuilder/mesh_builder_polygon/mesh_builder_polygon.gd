@tool
extends MeshBuilderShape
class_name MeshBuilderPolygon
@icon("res://addons/meshbuilder/mesh_builder_polygon/icon.svg")

@export var height :float = 0.1
@export var vertices :Array = [Vector2(1.0,1.0),Vector2(1.0,-1.0),Vector2(-1.0,-1.0),Vector2(-1.0,1.0)]

func _init(params=[height, [Vector2(1.0,1.0),Vector2(1.0,-1.0),Vector2(-1.0,-1.0),Vector2(-1.0,1.0)],0]):
	self.height = params[0]
	self.vertices = params[1]
	self.operation = params[2]
	super._init(params)
	self.current_values = [height, vertices]

func update():
	var needs_redraw = super.update()
	for child in get_children():
		if child.update():
			needs_redraw = true
	if self.current_values != [height, vertices]:
		self.current_values = [height, vertices]
		needs_redraw = true
	
	return needs_redraw

func get_csg():
	return CSG.polygon(height, vertices).scale(scale).rotate(rotation).translate(position)
