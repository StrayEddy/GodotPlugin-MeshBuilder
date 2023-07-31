tool
extends CSGTorus
class_name MeshBuilderTorus

func init(params=[0.5,1.0,6,8,true,0]):
	self.inner_radius = params[0]
	self.outer_radius = params[1]
	self.ring_sides = params[2]
	self.sides = params[3]
	self.smooth_faces = params[4]
	self.operation = params[5]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Torus",
		"params": [stepify(inner_radius,0.001), stepify(outer_radius,0.001), ring_sides, sides, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [stepify(scale.x,0.001), stepify(scale.y,0.001), stepify(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [stepify(rotation.x,0.001), stepify(rotation.y,0.001), stepify(rotation.z,0.001)]
	if translation != Vector3.ZERO:
		json["position"] = [stepify(translation.x,0.001), stepify(translation.y,0.001), stepify(translation.z,0.001)]
	
	return json
