@tool
extends CSGBox3D
class_name MeshBuilderBox

func init(params=[[1,1,1],0]):
	self.size = Vector3(params[0][0], params[0][1], params[0][2])
	self.operation = params[1]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Box",
		"params": [[snapped(size.x,0.001),snapped(size.y,0.001),snapped(size.z,0.001)], operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
