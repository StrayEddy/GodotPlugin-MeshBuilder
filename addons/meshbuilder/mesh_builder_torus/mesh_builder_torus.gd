@tool
extends CSGTorus3D
class_name MeshBuilderTorus
@icon("res://addons/meshbuilder/mesh_builder_torus/icon.svg")

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
		"params": [snapped(inner_radius,0.001), snapped(outer_radius,0.001), ring_sides, sides, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
