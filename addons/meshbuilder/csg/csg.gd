@tool
extends Node
class_name CSG
#    Constructive Solid Geometry (CSG) is a modeling technique that uses Boolean
#    operations like union and intersection to combine 3D solids. This library
#    implements CSG operations on meshes elegantly and concisely using BSP trees,
#    and is meant to serve as an easily understandable implementation of the
#    algorithm. All edge cases involving overlapping coplanar polygons in both
#    solids are correctly handled.
#
#    Example usage::
#
#        from csg.core import CSG
#
#        cube = CSG.cube();
#        sphere = CSG.sphere({'radius': 1.3});
#        polygons = cube.subtract(sphere).toPolygons();
#
#    ## Implementation Details
#
#    All CSG operations are implemented in terms of two functions, `clipTo()` and
#    `invert()`, which remove parts of a BSP tree inside another BSP tree and swap
#    solid and empty space, respectively. To find the union of `a` and `b`, we
#    want to remove everything in `a` inside `b` and everything in `b` inside `a`,
#    then combine polygons from `a` and `b` into one solid::
#
#        a.clipTo(b);
#        b.clipTo(a);
#        a.build(b.allPolygons());
#
#    The only tricky part is handling overlapping coplanar polygons in both trees.
#    The code above keeps both copies, but we need to keep them in one tree and
#    remove them in the other tree. To remove them from `b` we can clip the
#    inverse of `b` against `a`. The code for union now looks like this::
#
#        a.clipTo(b);
#        b.clipTo(a);
#        b.invert();
#        b.clipTo(a);
#        b.invert();
#        a.build(b.allPolygons());
#
#    Subtraction and intersection naturally follow from set operations. If
#    union is `A | B`, subtraction is `A - B = ~(~A | B)` and intersection is
#    `A & B = ~(~A | ~B)` where `~` is the complement operator.

var polygons = []

static func from_polygons(polygons):
	var csg = CSG.new()
	csg.polygons = polygons
	return csg

func clone():
	var csg = CSG.new()
	var polygons = []
	for poly in self.polygons:
		polygons.append(poly.clone())
	csg.polygons = polygons
	return csg

func to_polygons():
	return polygons

# Return a refined CSG. To each polygon, a middle
# point is added to each edge and to the center of
# the polygon
func refine():
	var new_csg = CSG.new()
	for poly in polygons:
		var verts :Array = poly.vertices
		var nb_verts = verts.size()
		if nb_verts == 0:
			continue
		
		var accum = Vector3.ZERO
		for vert in verts:
			accum += vert.pos
		var mid_pos = accum / float(nb_verts)
		var mid_normal = null
		if verts[0].normal != null:
			mid_normal = poly.plane.normal
		var mid_vert = Vertex.new().init(mid_pos, mid_normal)
		
		var new_verts = verts
		for i in range(nb_verts):
			var vert = verts[i].interpolate(verts[(i+1) % nb_verts], 0.5)
			new_verts.append(vert)
		new_verts.append_array([mid_vert])

		var i = 0
		var vs = [new_verts[i], new_verts[i+nb_verts], new_verts[2*nb_verts], new_verts[2*nb_verts-1]]
		var new_poly = Polygon.new()
		new_poly.vertices = vs
		new_poly.shared = poly.shared
		new_poly.plane = poly.plane
		new_csg.polygons.append(new_poly)
		
		for j in range(1, nb_verts):
			var vs_2 = [new_verts[j], new_verts[nb_verts+j], new_verts[2*nb_verts], new_verts[nb_verts+j-1]]
			var new_poly_2 = Polygon.new()
			new_poly_2.vertices = vs_2
			new_csg.polygons.append(new_poly_2)
	return new_csg

# Translate Geometry.
# disp: displacement (Vector3)
func translate(value :Vector3):
	var vertices = []
	for poly in polygons:
		for v in poly.vertices:
			if v in vertices:
				continue
			else:
				vertices.append(v)
				v.pos = v.pos + value
	return self

func scale(value :Vector3):
	var vertices = []
	for poly in polygons:
		for v in poly.vertices:
			if v in vertices:
				continue
			else:
				vertices.append(v)
				v.pos = v.pos * value
	return self

func rotate(value :Vector3):
	var vertices = []
	for poly in polygons:
		for v in poly.vertices:
			if v in vertices:
				continue
			else:
				vertices.append(v)
				v.pos = v.pos.rotated(Vector3.RIGHT, value.x)
				v.pos = v.pos.rotated(Vector3.UP, value.y)
				v.pos = v.pos.rotated(Vector3.BACK, value.z)
	return self

# Rotate geometry.
# axis: axis of rotation (array of floats)
# angleDeg: rotation angle in degrees
func rotate_axis(axis :Vector3, angle_deg :float):
	var ax = axis.normalized()
	var cos_angle = cos(PI * angle_deg / 180)
	var sin_angle = sin(PI * angle_deg / 180)

	var new_vector = func(v :Vector3):
		var v_a :float = v.dot(ax)
		var v_perp :Vector3 = v - ax * v_a
		var v_perp_len = v_perp.length()
		if v_perp_len == 0:
			# vector is parallel to axis, no need to rotate
			return v
		
		var u1 :Vector3 = v_perp.normalized()
		var u2 :Vector3 = u1.cross(ax)
		var v_cos_a = v_perp_len * cos_angle
		var v_sin_a = v_perp_len * sin_angle
		
		var result :Vector3
		result = ax * v_a
		result += u1 * (v_cos_a + (u2 * v_sin_a))
		return result
	
	for poly in polygons:
		for vert in poly.vertices:
			vert.pos = new_vector.call(vert.pos)
			var normal = vert.normal
			if normal.length() > 0:
				vert.normal = new_vector.call(vert.normal)
	return self

func print_1():
	print("nb of polygons: " + str(len(polygons)))
	for poly in polygons:
		print("poly with " + str(len(poly.vertices)) + " vertices")

func print_2():
	print("nb of polygons: " + str(len(polygons)))
	for poly in polygons:
		print("poly with " + str(len(poly.vertices)) + " vertices")
		for vert in poly.vertices:
			print("vert: " + str(vert.pos))

# Return a new CSG solid representing space in either this solid or in the
# solid `csg`. Neither this solid nor the solid `csg` are modified.::
#
#	A.union(B)
#
#	+-------+            +-------+
#	|       |            |       |
#	|   A   |            |       |
#	|    +--+----+   =   |       +----+
#	+----+--+    |       +----+       |
#		 |   B   |            |       |
#		 |       |            |       |
#		 +-------+            +-------+
func union(csg):
	var a = BSPNode.new().init(self.clone().polygons)
	var b = BSPNode.new().init(csg.clone().polygons)
	a.clip_to(b)
	b.clip_to(a)
	b.invert()
	b.clip_to(a)
	b.invert()
	a.build(b.all_polygons());
	return CSG.from_polygons(a.all_polygons())

# Return a new CSG solid representing space in this solid but not in the
# solid `csg`. Neither this solid nor the solid `csg` are modified.::
#
#	A.subtract(B)
#
#	+-------+            +-------+
#	|       |            |       |
#	|   A   |            |       |
#	|    +--+----+   =   |    +--+
#	+----+--+    |       +----+
#		 |   B   |
#		 |       |
#		 +-------+
func subtract(csg):
	var a = BSPNode.new().init(self.clone().polygons)
	var b = BSPNode.new().init(csg.clone().polygons)
	a.invert()
	a.clip_to(b)
	b.clip_to(a)
	b.invert()
	b.clip_to(a)
	b.invert()
	a.build(b.all_polygons())
	a.invert()
	return CSG.from_polygons(a.all_polygons())

# Return a new CSG solid representing space both this solid and in the
# solid `csg`. Neither this solid nor the solid `csg` are modified.::
#
#	A.intersect(B)
#
#	+-------+
#	|       |
#	|   A   |
#	|    +--+----+   =   +--+
#	+----+--+    |       +--+
#		 |   B   |
#		 |       |
#		 +-------+
func intersect(csg):
	var a = BSPNode.new().init(self.clone().polygons)
	var b = BSPNode.new().init(csg.clone().polygons)
	a.invert()
	b.clip_to(a)
	b.invert()
	a.clip_to(b)
	b.clip_to(a)
	a.build(b.all_polygons())
	a.invert()
	return CSG.from_polygons(a.all_polygons())

# Return a new CSG solid with solid and empty space switched. This solid is
# not modified.
func inverse():
	var csg = self.clone()
	for p in csg.polygons:
		p.flip()
	return csg

static func cone(height :float = 1.0, radius :float = 1.0, slices :int = 16):
	var s = Vector3(0,-1,0) * height
	var e = Vector3(0,1,0) * height
	var r = radius
	var ray = e - s
	
	var axis_z = ray.normalized()
	var is_y = abs(axis_z.y) > 0.5
	var axis_x = Vector3(float(is_y), float(not is_y), 0).cross(axis_z).normalized()
	var axis_y = axis_x.cross(axis_z).normalized()
	var start_normal = -axis_z
	var start_vertex = Vertex.new().init(s, start_normal)
	var polygons = []
	
	var taper_angle = atan2(r, ray.length())
	var sin_taper_angle = sin(taper_angle)
	var cos_taper_angle = cos(taper_angle)
	var point = func(angle):
		# radial direction pointing out
		var out = (axis_x * cos(angle)) + (axis_y * sin(angle))
		var pos = s + (out * r)
		# normal taking into account the tapering of the cone
		var normal = (out * cos_taper_angle) + (axis_z * sin_taper_angle)
		return [pos, normal]

	var dt = PI * 2.0 / float(slices)
	for i in range(0, slices):
		var t0 = i * dt
		var i1 = (i + 1) % slices
		var t1 = i1 * dt
		# coordinates and associated normal pointing outwards of the cone's
		# side
		var v0 = point.call(t0)
		var v1 = point.call(t1)
		var p0 = v0[0]
		var n0 = v0[1]
		var p1 = v1[0]
		var n1 = v1[1]
		# average normal for the tip
		var n_avg = (n0 + n1) * 0.5
		# polygon on the low side (disk sector)
		var poly_start = Polygon.new().init([start_vertex.clone(), Vertex.new().init(p0, start_normal), Vertex.new().init(p1, start_normal)])
		polygons.append(poly_start)
		# polygon extending from the low side to the tip
		var poly_side = Polygon.new().init([Vertex.new().init(p0, n0), Vertex.new().init(e, n_avg), Vertex.new().init(p1, n1)])
		polygons.append(poly_side)

	return CSG.from_polygons(polygons)

static func cube():
	var px_py_pz = Vector3(.5,.5,.5)
	var px_py_pZ = Vector3(.5,.5,-.5)
	var px_pY_pz = Vector3(.5,-.5,.5)
	var px_pY_pZ = Vector3(.5,-.5,-.5)
	var pX_py_pz = Vector3(-.5,.5,.5)
	var pX_py_pZ = Vector3(-.5,.5,-.5)
	var pX_pY_pz = Vector3(-.5,-.5,.5)
	var pX_pY_pZ = Vector3(-.5,-.5,-.5)
	
	var vertices = []
	vertices.append(Vertex.new().init(pX_pY_pZ))
	vertices.append(Vertex.new().init(pX_pY_pz))
	vertices.append(Vertex.new().init(pX_py_pZ))
	vertices.append(Vertex.new().init(pX_py_pz))
	vertices.append(Vertex.new().init(px_pY_pZ))
	vertices.append(Vertex.new().init(px_pY_pz))
	vertices.append(Vertex.new().init(px_py_pZ))
	vertices.append(Vertex.new().init(px_py_pz))
	
	var polygons_to_build = [[0,1,2],[3,2,1],[0,4,1],[5,1,4],[0,2,4],[6,4,2],[7,5,6],[4,6,5],[7,6,3],[2,3,6],[7,3,5],[1,5,3]]
	var polygons = []
	for poly in polygons_to_build:
		var v0 = vertices[poly[0]]
		var v1 = vertices[poly[1]]
		var v2 = vertices[poly[2]]
		polygons.append(Polygon.new().init([v0,v1,v2]))
	
	return CSG.from_polygons(polygons)

static func cylinder(height :float = 1.0, radius :float = 1.0, slices :int = 16):
	var s = Vector3(0,-1,0) * height
	var e = Vector3(0,1,0) * height
	var r = radius
	var ray = e - s

	var axis_z = ray.normalized()
	var is_y = abs(axis_z.y) > 0.5
	var axis_x = Vector3(float(is_y), float(not is_y), 0).cross(axis_z).normalized()
	var axis_y = axis_x.cross(axis_z).normalized()
	var start_vert = Vertex.new().init(s, -axis_z)
	var end_vert = Vertex.new().init(e, axis_z.normalized())
	var polygons = []
	
	var point = func(stack, angle):
		var out = (axis_x * cos(angle)) + (axis_y * sin(angle))
		var pos = s + (ray * stack) + (out * r)
		return Vertex.new().init(pos)
		
	var dt = PI * 2.0 / float(slices)
	for i in range(0, slices):
		var t0 = i * dt
		var i1 = (i + 1) % slices
		var t1 = i1 * dt
		polygons.append(Polygon.new().init([start_vert, point.call(0., t0), point.call(0., t1)]))
		polygons.append(Polygon.new().init([point.call(0., t0), point.call(1., t0), point.call(1., t1)]))
		polygons.append(Polygon.new().init([point.call(1., t1), point.call(0., t1), point.call(0., t0)]))
		polygons.append(Polygon.new().init([end_vert, point.call(1., t1), point.call(1., t0)]))
	
	return CSG.from_polygons(polygons)

static func ring(height :float = 1.0, inner_radius :float = 0.5, outer_radius :float = 1.0, slices :int = 16):
	var s = Vector3(0,-1,0) * height
	var e = Vector3(0,1,0) * height
	var ray = e - s

	var axis_z = ray.normalized()
	var is_y = abs(axis_z.y) > 0.5
	var axis_x = Vector3(float(is_y), float(not is_y), 0).cross(axis_z).normalized()
	var axis_y = axis_x.cross(axis_z).normalized()
	var polygons = []
	
	var outer_point = func(stack, angle):
		var out = (axis_x * cos(angle)) + (axis_y * sin(angle))
		var pos = s + (ray * stack) + (out * outer_radius)
		return Vertex.new().init(pos)
	
	var inner_point = func(stack, angle):
		var out = (axis_x * cos(angle)) + (axis_y * sin(angle))
		var pos = s + (ray * stack) + (out * inner_radius)
		return Vertex.new().init(pos)
	
	var dt = PI * 2.0 / float(slices)
	for i in range(0, slices):
		var t0 = i * dt
		var i1 = (i + 1) % slices
		var t1 = i1 * dt
		
		polygons.append(Polygon.new().init([outer_point.call(0., t1), inner_point.call(0., t1), inner_point.call(0., t0), outer_point.call(0., t0)]))
		polygons.append(Polygon.new().init([outer_point.call(1., t0), inner_point.call(1., t0), inner_point.call(1., t1), outer_point.call(1., t1)]))
		polygons.append(Polygon.new().init([inner_point.call(0., t0), inner_point.call(0., t1), inner_point.call(1., t1), inner_point.call(1., t0)]))
		polygons.append(Polygon.new().init([outer_point.call(1., t0), outer_point.call(1., t1), outer_point.call(0., t1), outer_point.call(0., t0)]))
	
	return CSG.from_polygons(polygons)

static func sphere(slices :int = 12, stacks :int = 6):
	var c = Vector3.ZERO # center
	var r = 1.0 # radius
	var polygons = []
	var append_vertex = func(vertices, theta, phi):
		var d = Vector3(cos(theta) * sin(phi),
			cos(phi), 
			sin(theta) * sin(phi))
		vertices.append(Vertex.new().init(c + d * r, d))
		
	var dTheta = PI * 2.0 / float(slices)
	var dPhi = PI / float(stacks)

	var j0 = 0
	var j1 = j0 + 1
	for i0 in range(0, slices):
		var i1 = i0 + 1
		#  +--+
		#  | /
		#  |/
		#  +
		var vertices = []
		append_vertex.call(vertices, i0 * dTheta, j0 * dPhi)
		append_vertex.call(vertices, i1 * dTheta, j1 * dPhi)
		append_vertex.call(vertices, i0 * dTheta, j1 * dPhi)
		polygons.append(Polygon.new().init(vertices))

	j0 = stacks - 1
	j1 = j0 + 1
	for i0 in range(0, slices):
		var i1 = i0 + 1
		#  +
		#  |\
		#  | \
		#  +--+
		var vertices = []
		append_vertex.call(vertices, i0 * dTheta, j0 * dPhi)
		append_vertex.call(vertices, i1 * dTheta, j0 * dPhi)
		append_vertex.call(vertices, i0 * dTheta, j1 * dPhi)
		polygons.append(Polygon.new().init(vertices))
		
	for k0 in range(1, stacks - 1):
		var k1 = k0 + 1
		for i0 in range(0, slices):
			var i1 = i0 + 1
			#  +---+
			#  |\ /|
			#  | x |
			#  |/ \|
			#  +---+
			var verticesL = []
			append_vertex.call(verticesL, i0 * dTheta, k0 * dPhi)
			append_vertex.call(verticesL, i1 * dTheta, k1 * dPhi)
			append_vertex.call(verticesL, i0 * dTheta, k1 * dPhi)
			polygons.append(Polygon.new().init(verticesL))
			var verticesR = []
			append_vertex.call(verticesR, i0 * dTheta, k0 * dPhi)
			append_vertex.call(verticesR, i1 * dTheta, k0 * dPhi)
			append_vertex.call(verticesR, i1 * dTheta, k1 * dPhi)
			polygons.append(Polygon.new().init(verticesR))
			
	return CSG.from_polygons(polygons)

static func torus(innerR :float = 0.5, outerR :float = 1.0, stacks :int = 8, slices :int = 6):
	# ring radius (thick part of donut)
	var phi = 0.0
	var dp = (2*PI) / slices
	# torus radius (whole donut shape)
	var theta = 0.0
	var dt = (2*PI) / stacks

	var vertices = []
	for stack in stacks:
		theta = dt * stack
		for slice in slices:
			phi = dp * slice
			var v = Vector3()
			v.x = cos(theta) * (outerR + cos(phi) * innerR)
			v.y = sin(theta) * (outerR + cos(phi) * innerR)
			v.z = sin(phi) * innerR
			vertices.append(Vertex.new().init(v))
	
	var polygons = []
	for stack in stacks:
		for slice in slices:
			var i0 = (slice + (stack * slices))
			var i1 = ((slice+1) % slices) + (stack * slices)
			var i2 = ((slice+1) % slices) + (((stack+1) % stacks) * slices)
			var i3 = slice + (((stack+1) % stacks) * slices)
			var verts = [vertices[i3],vertices[i2],vertices[i1],vertices[i0]]
			polygons.append(Polygon.new().init(verts))
	
	return CSG.from_polygons(polygons)
