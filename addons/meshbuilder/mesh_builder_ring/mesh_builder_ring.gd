tool
extends CSGMesh
class_name MeshBuilderRing

export(float) var height = 1.0 setget setHeight, getHeight
func setHeight(value):
	value = clamp(value,0,1000000)
	height = value
	update_mesh()
func getHeight():
	return height

export(float) var top_inner_radius = 0.5 setget setTopInnerRadius, getTopInnerRadius
func setTopInnerRadius(value):
	value = clamp(value,0,1000000)
	top_inner_radius = value
	update_mesh()
func getTopInnerRadius():
	return top_inner_radius
		
export(float) var top_outer_radius = 1.0 setget setTopOuterRadius, getTopOuterRadius
func setTopOuterRadius(value):
	value = clamp(value,0,1000000)
	top_outer_radius = value
	update_mesh()
func getTopOuterRadius():
	return top_outer_radius

export(float) var bottom_inner_radius = 0.5 setget setBottomInnerRadius, getBottomInnerRadius
func setBottomInnerRadius(value):
	value = clamp(value,0,1000000)
	bottom_inner_radius = value
	update_mesh()
func getBottomInnerRadius():
	return bottom_inner_radius

export(float) var bottom_outer_radius = 1.0 setget setBottomOuterRadius, getBottomOuterRadius
func setBottomOuterRadius(value):
	value = clamp(value,0,1000000)
	bottom_outer_radius = value
	update_mesh()
func getBottomOuterRadius():
	return bottom_outer_radius

export(int) var sides = 8 setget setSides, getSides
func setSides(value):
	sides = value
	update_mesh()
func getSides():
	return sides

export(bool) var smooth_faces = true setget setSmoothFaces, getSmoothFaces
func setSmoothFaces(value):
	smooth_faces = value
	update_mesh()
func getSmoothFaces():
	return smooth_faces

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
	var bottom_vertices :PoolVector3Array = []
	var top_vertices :PoolVector3Array = []
	var side_vertices :PoolVector3Array = []
	
	var s = Vector3(0,-1,0) * height
	var e = Vector3(0,1,0) * height
	var ray = e - s

	var axis_z = ray.normalized()
	var is_y = abs(axis_z.y) > 0.5
	var axis_x = Vector3(float(is_y), float(not is_y), 0).cross(axis_z).normalized()
	var axis_y = axis_x.cross(axis_z).normalized()

	var dt = PI * 2.0 / float(sides)
	for i in range(0, sides):
		var t0 = i * dt
		var i1 = (i + 1) % sides
		var t1 = i1 * dt
		
		# bottom portion
		bottom_vertices.append_array([point(axis_x, axis_y, s, ray, 0.0, t1, bottom_outer_radius), point(axis_x, axis_y, s, ray, 0.0, t1, bottom_inner_radius), point(axis_x, axis_y, s, ray, 0.0, t0, bottom_inner_radius)])
		bottom_vertices.append_array([point(axis_x, axis_y, s, ray, 0.0, t0, bottom_inner_radius), point(axis_x, axis_y, s, ray, 0.0, t0, bottom_outer_radius), point(axis_x, axis_y, s, ray, 0.0, t1, bottom_outer_radius)])
		
		# top portion
		top_vertices.append_array([point(axis_x, axis_y, s, ray, 1.0, t0, top_outer_radius), point(axis_x, axis_y, s, ray, 1.0, t0, top_inner_radius), point(axis_x, axis_y, s, ray, 1.0, t1, top_inner_radius)])
		top_vertices.append_array([point(axis_x, axis_y, s, ray, 1.0, t1, top_inner_radius), point(axis_x, axis_y, s, ray, 1.0, t1, top_outer_radius), point(axis_x, axis_y, s, ray, 1.0, t0, top_outer_radius)])
		
		# sides
		side_vertices.append_array([point(axis_x, axis_y, s, ray, 0.0, t0, bottom_inner_radius), point(axis_x, axis_y, s, ray, 0.0, t1, bottom_inner_radius), point(axis_x, axis_y, s, ray, 1.0, t1, top_inner_radius)])
		side_vertices.append_array([point(axis_x, axis_y, s, ray, 1.0, t1, top_inner_radius), point(axis_x, axis_y, s, ray, 1.0, t0, top_inner_radius), point(axis_x, axis_y, s, ray, 0.0, t0, bottom_inner_radius)])
		
		side_vertices.append_array([point(axis_x, axis_y, s, ray, 1.0, t0, top_outer_radius), point(axis_x, axis_y, s, ray, 1.0, t1, top_outer_radius), point(axis_x, axis_y, s, ray, 0.0, t1, bottom_outer_radius)])
		side_vertices.append_array([point(axis_x, axis_y, s, ray, 0.0, t1, bottom_outer_radius), point(axis_x, axis_y, s, ray, 0.0, t0, bottom_outer_radius), point(axis_x, axis_y, s, ray, 1.0, t0, top_outer_radius)])
	
	# Create the Mesh.
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	bottom_vertices.invert()
	top_vertices.invert()
	side_vertices.invert()
	
	for i in range(bottom_vertices.size()):
		st.add_vertex(bottom_vertices[i])
	
	for i in range(top_vertices.size()):
		st.add_vertex(top_vertices[i])
	
	for i in range(side_vertices.size()):
#		st.set_smooth_group(1)
		st.add_vertex(side_vertices[i])
	
	if smooth_faces:
		st.generate_normals()
	
	if self.mesh == null:
		self.mesh = st.commit()
	else:
		self.mesh.clear_surfaces()
		st.commit(self.mesh)
	self.mesh.emit_changed()

func point(axis_x, axis_y, s, ray, stack, angle, radius):
	var out = (axis_x * cos(angle)) + (axis_y * sin(angle))
	var pos = s + (ray * stack) + (out * radius)
	return pos

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Ring",
		"params": [stepify(height,0.001), stepify(top_inner_radius,0.001), stepify(top_outer_radius,0.001), stepify(bottom_inner_radius,0.001), stepify(bottom_outer_radius,0.001), sides, smooth_faces, operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [stepify(scale.x,0.001), stepify(scale.y,0.001), stepify(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [stepify(rotation.x,0.001), stepify(rotation.y,0.001), stepify(rotation.z,0.001)]
	if translation != Vector3.ZERO:
		json["position"] = [stepify(translation.x,0.001), stepify(translation.y,0.001), stepify(translation.z,0.001)]
	
	return json
