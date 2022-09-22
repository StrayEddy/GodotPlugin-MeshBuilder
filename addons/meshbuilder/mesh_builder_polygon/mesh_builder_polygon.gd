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
		if child is CSGShape3D:
			children.append(child.to_json())
	var polygon_array = []
	for vector2 in self.polygon:
		polygon_array.append([snapped(vector2.x,0.001), snapped(vector2.y,0.001)])
	
	var json = {
		"name": "Polygon",
		"params": [snapped(depth,0.001), polygon_array, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
