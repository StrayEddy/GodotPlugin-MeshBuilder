tool
extends CSGPolygon
class_name MeshBuilderPolygon

func init(params=[1.0,[[0,0],[0,1],[1,1],[1,0]],true,0]):
	self.depth = params[0]
	var polygon_array = []
	for vertex in params[1]:
		polygon_array.append(Vector2(vertex[0],vertex[1]))
	self.polygon = PoolVector2Array(polygon_array)
	self.smooth_faces = params[2]
	self.operation = params[3]
	return self

func to_json():
	var children = []
	for child in get_children():
		if child is CSGShape:
			children.append(child.to_json())
	var polygon_array = []
	for vector2 in self.polygon:
		polygon_array.append([stepify(vector2.x,0.001), stepify(vector2.y,0.001)])
	
	var json = {
		"name": "Polygon",
		"params": [stepify(depth,0.001), polygon_array, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [stepify(scale.x,0.001), stepify(scale.y,0.001), stepify(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [stepify(rotation.x,0.001), stepify(rotation.y,0.001), stepify(rotation.z,0.001)]
	if translation != Vector3.ZERO:
		json["position"] = [stepify(translation.x,0.001), stepify(translation.y,0.001), stepify(translation.z,0.001)]
	
	return json
