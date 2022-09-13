@tool
extends CSGSphere3D
class_name MeshBuilderSphere
@icon("res://addons/meshbuilder/mesh_builder_sphere/icon.svg")

func _init(params=[12,0.5,6,true,0]):
	self.radial_segments = params[0]
	self.radius = params[1]
	self.rings = params[2]
	self.smooth_faces = params[3]
	self.operation = params[4]
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
		"params": [radial_segments, radius, rings, smooth_faces, operation],
		"children": children
	}
	return json
