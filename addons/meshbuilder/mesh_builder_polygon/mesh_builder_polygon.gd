@tool
extends CSGPolygon3D
class_name MeshBuilderPolygon
@icon("res://addons/meshbuilder/mesh_builder_polygon/icon.svg")

func _init(params=[1.0,PackedVector2Array([Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(1,0)]),true,0]):
	self.depth = params[0]
	self.polygon = params[1]
	self.smooth_faces = params[2]
	self.operation = params[3]
	super._init()

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": name,
		"scale": [scale.x, scale.y, scale.z],
		"rotation": [rotation.x, rotation.y, rotation.z],
		"position": [position.x, position.y, position.z],
		"params": [depth, polygon, smooth_faces, operation],
		"children": children
	}
	return json
