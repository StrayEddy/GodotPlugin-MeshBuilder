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
		"scale": [scale.x, scale.y, scale.z],
		"rotation": [rotation.x, rotation.y, rotation.z],
		"position": [position.x, position.y, position.z],
		"params": [inner_radius, outer_radius, ring_sides, sides, smooth_faces, operation],
		"children": children
	}
	return json
