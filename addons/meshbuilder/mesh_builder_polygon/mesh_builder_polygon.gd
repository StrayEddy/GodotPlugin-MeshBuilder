@tool
extends CSGPolygon3D
class_name MeshBuilderPolygon
@icon("res://addons/meshbuilder/mesh_builder_polygon/icon.svg")

func init(params=[1.0,[[0,0],[0,1],[1,1],[1,0]],true,0]):
	self.depth = params[0]
	var polygon_array = []
	for vertex in params[1]:
		polygon_array.append(Vector2(vertex[0],vertex[1]))
	self.polygon = PackedVector2Array(polygon_array)
	self.smooth_faces = params[2]
	self.operation = params[3]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var polygon_array = []
	for vector2 in self.polygon:
		polygon_array.append([vector2.x, vector2.y])
	
	var json = {
		"name": "Polygon",
		"scale": [scale.x, scale.y, scale.z],
		"rotation": [rotation.x, rotation.y, rotation.z],
		"position": [position.x, position.y, position.z],
		"params": [depth, polygon_array, smooth_faces, operation],
		"children": children
	}
	return json
