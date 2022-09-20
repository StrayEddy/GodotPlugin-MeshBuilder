@tool
extends CSGCylinder3D
class_name MeshBuilderCylinder
@icon("res://addons/meshbuilder/mesh_builder_cylinder/icon.svg")

func init(params=[false,2.0,0.5,8,true,0]):
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
		"name": "Cylinder",
		"params": [cone, snapped(height,0.001), snapped(radius,0.001), sides, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
