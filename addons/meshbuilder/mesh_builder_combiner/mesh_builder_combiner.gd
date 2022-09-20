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
		"name": "Combiner",
		"scale": [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)],
		"rotation": [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)],
		"position": [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)],
		"params": [operation],
		"children": children
	}
	return json
