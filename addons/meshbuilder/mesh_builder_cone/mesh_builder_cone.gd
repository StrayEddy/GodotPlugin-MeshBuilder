@tool
extends CSGCylinder3D
class_name MeshBuilderCone
@icon("res://addons/meshbuilder/mesh_builder_cone/icon.svg")

func _init(params=[true,2.0,0.5,8,true,0]):
	self.cone = params[0]
	self.height = params[1]
	self.radius = params[2]
	self.sides = params[3]
	self.smooth_faces = params[4]
	self.operation = params[5]
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
		"params": [cone, height, radius, sides, smooth_faces, operation],
		"children": children
	}
	return json
