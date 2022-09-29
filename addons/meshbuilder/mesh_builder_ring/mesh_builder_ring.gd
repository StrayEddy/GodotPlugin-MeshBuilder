@tool
extends CSGMesh3D
class_name MeshBuilderRing
@icon("res://addons/meshbuilder/mesh_builder_ring/small-icon.svg")

@export var height :float = 1.0 :
	get:
		return height
	set(value):
		value = clamp(value,0,1000000)
		height = value
		update_mesh()

@export var top_inner_radius :float = 0.5 :
	get:
		return top_inner_radius
	set(value):
		value = clamp(value,0,1000000)
		top_inner_radius = value
		update_mesh()
		
@export var top_outer_radius :float = 1.0 :
	get:
		return top_outer_radius
	set(value):
		value = clamp(value,0,1000000)
		top_outer_radius = value
		update_mesh()

@export var bottom_inner_radius :float = 0.5 :
	get:
		return bottom_inner_radius
	set(value):
		value = clamp(value,0,1000000)
		bottom_inner_radius = value
		update_mesh()

@export var bottom_outer_radius :float = 1.0 :
	get:
		return bottom_outer_radius
	set(value):
		value = clamp(value,0,1000000)
		bottom_outer_radius = value
		update_mesh()

@export var sides :int = 8 :
	get:
		return sides
	set(value):
		sides = value
		update_mesh()

@export var smooth_faces :bool = true :
	get:
		return smooth_faces
	set(value):
		smooth_faces = value
		update_mesh()

func init(params=[1.0, 0.5, 1.0, 0.5, 1.0, 8, true, 0]):
	self.height = params[0]
	self.top_inner_radius = params[1]
	self.top_outer_radius = params[2]
	self.bottom_inner_radius = params[3]
	self.bottom_outer_radius = params[4]
	self.sides = params[5]
	self.smooth_faces = params[6]
	self.operation = params[7]
	update_mesh()
	return self

func update_mesh():
	var bottom_vertices :PackedVector3Array = []
	var top_vertices :PackedVector3Array = []
	var side_vertices :PackedVector3Array = []
	
	var s = Vector3(0,-1,0) * height
	var e = Vector3(0,1,0) * height
	var ray = e - s

	var axis_z = ray.normalized()
	var is_y = abs(axis_z.y) > 0.5
	var axis_x = Vector3(float(is_y), float(not is_y), 0).cross(axis_z).normalized()
	var axis_y = axis_x.cross(axis_z).normalized()

	var point = func(stack, angle, radius):
		var out = (axis_x * cos(angle)) + (axis_y * sin(angle))
		var pos = s + (ray * stack) + (out * radius)
		return pos

	var dt = PI * 2.0 / float(sides)
	for i in range(0, sides):
		var t0 = i * dt
		var i1 = (i + 1) % sides
		var t1 = i1 * dt
		
		# bottom portion
		bottom_vertices.append_array([point.call(0., t1, bottom_outer_radius), point.call(0., t1, bottom_inner_radius), point.call(0., t0, bottom_inner_radius)])
		bottom_vertices.append_array([point.call(0., t0, bottom_inner_radius), point.call(0., t0, bottom_outer_radius), point.call(0., t1, bottom_outer_radius)])
		
		# top portion
		top_vertices.append_array([point.call(1., t0, top_outer_radius), point.call(1., t0, top_inner_radius), point.call(1., t1, top_inner_radius)])
		top_vertices.append_array([point.call(1., t1, top_inner_radius), point.call(1., t1, top_outer_radius), point.call(1., t0, top_outer_radius)])
		
		# sides
		side_vertices.append_array([point.call(0., t0, bottom_inner_radius), point.call(0., t1, bottom_inner_radius), point.call(1., t1, top_inner_radius)])
		side_vertices.append_array([point.call(1., t1, top_inner_radius), point.call(1., t0, top_inner_radius), point.call(0., t0, bottom_inner_radius)])
		
		side_vertices.append_array([point.call(1., t0, top_outer_radius), point.call(1., t1, top_outer_radius), point.call(0., t1, bottom_outer_radius)])
		side_vertices.append_array([point.call(0., t1, bottom_outer_radius), point.call(0., t0, bottom_outer_radius), point.call(1., t0, top_outer_radius)])
	
	# Create the Mesh.
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	bottom_vertices.reverse()
	top_vertices.reverse()
	side_vertices.reverse()
	
	for i in range(bottom_vertices.size()):
		st.add_vertex(bottom_vertices[i])
	
	for i in range(top_vertices.size()):
		st.add_vertex(top_vertices[i])
	
	for i in range(side_vertices.size()):
		st.set_smooth_group(1)
		st.add_vertex(side_vertices[i])
	
	if smooth_faces:
		st.generate_normals()
	
	if self.mesh == null:
		self.mesh = st.commit()
	else:
		self.mesh.clear_surfaces()
		st.commit(self.mesh)
	self.mesh.emit_changed()

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Ring",
		"params": [snapped(height,0.001), snapped(top_inner_radius,0.001), snapped(top_outer_radius,0.001), snapped(bottom_inner_radius,0.001), snapped(bottom_outer_radius,0.001), sides, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
