@tool
extends CSGMesh3D
class_name MeshBuilderMesh
@icon("res://addons/meshbuilder/mesh_builder_mesh/icon.svg")

func init(params=["BoxMesh",[],false, 0]):
	match params[0]:
		"BoxMesh":
			self.mesh = BoxMesh.new()
			if params[1].is_empty():
				params[1] = [[1,1,1],0,0,0]
			self.mesh.size = Vector3(params[1][0][0],params[1][0][1],params[1][0][2])
			self.mesh.subdivide_width = params[1][1]
			self.mesh.subdivide_height = params[1][2]
			self.mesh.subdivide_depth = params[1][3]
		"CylinderMesh":
			self.mesh = CylinderMesh.new()
			if params[1].is_empty():
				params[1] = [.5,.5,2,64,4,true,true]
			self.mesh.top_radius = params[1][0]
			self.mesh.bottom_radius = params[1][1]
			self.mesh.height = params[1][2]
			self.mesh.radial_segments = params[1][3]
			self.mesh.rings = params[1][4]
			self.mesh.cap_top = params[1][5]
			self.mesh.cap_bottom = params[1][6]
		"SphereMesh":
			self.mesh = SphereMesh.new()
			if params[1].is_empty():
				params[1] = [.5,1,64,32,false]
			self.mesh.radius = params[1][0]
			self.mesh.height = params[1][1]
			self.mesh.radial_segments = params[1][2]
			self.mesh.rings = params[1][3]
			self.mesh.is_hemisphere = params[1][4]
		"TorusMesh":
			self.mesh = TorusMesh.new()
			if params[1].is_empty():
				params[1] = [.5,1,64,32]
			self.mesh.inner_radius = params[1][0]
			self.mesh.outer_radius = params[1][1]
			self.mesh.rings = params[1][2]
			self.mesh.ring_segments = params[1][3]
	self.flip_faces = params[2]
	self.operation = params[3]
	return self

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	
	var params = []
	
	match mesh.get_class():
		"BoxMesh":
			params = [[mesh.size.x, mesh.size.y, mesh.size.z], mesh.subdivide_width, mesh.subdivide_height, mesh.subdivide_depth]
		"CylinderMesh":
			params = [mesh.top_radius, mesh.bottom_radius, mesh.height, mesh.radial_segments, mesh.rings, mesh.cap_top, mesh.cap_bottom]
		"SphereMesh":
			params = [mesh.radius, mesh.height, mesh.radial_segments, mesh.rings, mesh.is_hemisphere]
		"TorusMesh":
			params = [mesh.inner_radius, mesh.outer_radius, mesh.rings, mesh.ring_segments]
	
	var json = {
		"name": "Mesh",
		"params": [self.mesh.get_class(),params,self.flip_faces,self.operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
