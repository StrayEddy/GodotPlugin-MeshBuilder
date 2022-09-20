@tool
extends CSGSphere3D
class_name MeshBuilderSphere
@icon("res://addons/meshbuilder/mesh_builder_sphere/icon.svg")

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
		"params": [radial_segments, snapped(radius, 0.001), rings, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
