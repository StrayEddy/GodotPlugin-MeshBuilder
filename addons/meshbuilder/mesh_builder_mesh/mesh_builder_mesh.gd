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
		"CapsuleMesh":
			self.mesh = CapsuleMesh.new()
			if params[1].is_empty():
				params[1] = [.5,2,64,8]
			self.mesh.radius = params[1][0]
			self.mesh.height = params[1][1]
			self.mesh.radial_segments = params[1][2]
			self.mesh.rings = params[1][3]
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
		"PlaneMesh":
			self.mesh = PlaneMesh.new()
			if params[1].is_empty():
				params[1] = [[2,2],0,0,[0,0,0],1]
			self.mesh.size = Vector2(params[1][0][0],params[1][0][1])
			self.mesh.subdivide_width = params[1][1]
			self.mesh.subdivide_depth = params[1][2]
			self.mesh.center_offset = Vector3(params[1][3][0],params[1][3][1],params[1][3][2])
			self.mesh.orientation = params[1][4]
		"PrismMesh":
			self.mesh = PrismMesh.new()
			if params[1].is_empty():
				params[1] = [.5,[1,1,1],0,0,0]
			self.mesh.left_to_right = params[1][0]
			self.mesh.size = Vector3(params[1][1][0],params[1][1][1], params[1][1][2])
			self.mesh.subdivide_width = params[1][2]
			self.mesh.subdivide_height = params[1][3]
			self.mesh.subdivide_depth = params[1][4]
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
		"CapsuleMesh":
			params = [mesh.radius, mesh.height, mesh.radial_segments, mesh.rings]
		"CylinderMesh":
			params = [mesh.top_radius, mesh.bottom_radius, mesh.height, mesh.radial_segments, mesh.rings, mesh.cap_top, mesh.cap_bottom]
		"PlaneMesh":
			params = [[mesh.size.x, mesh.size.y], mesh.subdivide_width, mesh.subdivide_depth, [mesh.center_offset.x, mesh.center_offset.y, mesh.center_offset.z], mesh.orientation]
		"PrismMesh":
			params = [mesh.left_to_right, [mesh.size.x, mesh.size.y, mesh.size.z], mesh.subdivide_width, mesh.subdivide_height, mesh.subdivide_depth]
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
