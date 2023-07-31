tool
extends CSGCylinder
class_name MeshBuilderCone

func init(params=[true,2.0,0.5,8,true,0]):
	self.cone = params[0]
	self.height = params[1]
	self.radius = params[2]
	self.sides = params[3]
	self.smooth_faces = params[4]
	self.operation = params[5]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Cone",
		"params": [cone, stepify(height,0.001), stepify(radius,0.001), sides, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [stepify(scale.x,0.001), stepify(scale.y,0.001), stepify(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [stepify(rotation.x,0.001), stepify(rotation.y,0.001), stepify(rotation.z,0.001)]
	if translation != Vector3.ZERO:
		json["position"] = [stepify(translation.x,0.001), stepify(translation.y,0.001), stepify(translation.z,0.001)]
	
	return json
