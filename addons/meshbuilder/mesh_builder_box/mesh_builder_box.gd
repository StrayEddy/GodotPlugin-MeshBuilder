tool
extends CSGBox
class_name MeshBuilderBox

func init(params=[[1,1,1],0]):
	self.width = params[0][0]
	self.height = params[0][1]
	self.depth = params[0][2]
	self.operation = params[1]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Box",
		"params": [[stepify(self.width,0.001),stepify(self.height,0.001),stepify(self.depth,0.001)], operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [stepify(scale.x,0.001), stepify(scale.y,0.001), stepify(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [stepify(rotation.x,0.001), stepify(rotation.y,0.001), stepify(rotation.z,0.001)]
	if translation != Vector3.ZERO:
		json["position"] = [stepify(translation.x,0.001), stepify(translation.y,0.001), stepify(translation.z,0.001)]
	
	return json
