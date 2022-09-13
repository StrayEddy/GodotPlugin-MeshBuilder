@tool
extends CSGBox3D
class_name MeshBuilderBox

func _init(params=[[1,1,1],0]):
	self.size = Vector3(params[0][0], params[0][1], params[0][2])
	self.operation = params[1]
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
		"params": [[size.x,size.y,size.z], operation],
		"children": children
	}
	return json
