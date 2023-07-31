tool
extends CSGSphere
class_name MeshBuilderSphere

func init(params=[12,0.5,6,true,0]):
	self.radial_segments = params[0]
	self.radius = params[1]
	self.rings = params[2]
	self.smooth_faces = params[3]
	self.operation = params[4]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Sphere",
		"params": [radial_segments, stepify(radius, 0.001), rings, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [stepify(scale.x,0.001), stepify(scale.y,0.001), stepify(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [stepify(rotation.x,0.001), stepify(rotation.y,0.001), stepify(rotation.z,0.001)]
	if translation != Vector3.ZERO:
		json["position"] = [stepify(translation.x,0.001), stepify(translation.y,0.001), stepify(translation.z,0.001)]
	
	return json
