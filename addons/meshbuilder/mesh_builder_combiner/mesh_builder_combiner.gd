@tool
extends CSGCombiner3D
class_name MeshBuilderCombiner

func init(params=[0]):
	self.operation = params[0]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": name,
		"scale": [scale.x, scale.y, scale.z],
		"rotation": [rotation.x, rotation.y, rotation.z],
		"position": [position.x, position.y, position.z],
		"params": [operation],
		"children": children
	}
	return json
