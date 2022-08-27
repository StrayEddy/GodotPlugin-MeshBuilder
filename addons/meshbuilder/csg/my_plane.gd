@tool
extends Node
class_name MyPlane

# `MyPlane.EPSILON` is the tolerance used by `splitPolygon()` to decide if a
# point is on the plane.
const EPSILON = 1.e-6
var normal :Vector3
var d :float

var poly_script = load("res://addons/meshbuilder/csg/polygon.gd")

func init(normal :Vector3, d=0.0):
	self.normal = normal
	self.d = d
	return self

static func from_points(a :Vector3, b :Vector3, c :Vector3):
	var n = (b - a).cross(c - a).normalized()
	return MyPlane.new().init(n, n.dot(a))

func clone():
	return MyPlane.new().init(self.normal, self.d)
	
func flip():
	self.normal = -self.normal
	self.d = -self.d

# Split `polygon` by this plane if needed, then put the polygon or polygon
# fragments in the appropriate lists. Coplanar polygons go into either
# `coplanarFront` or `coplanarBack` depending on their orientation with
# respect to this plane. Polygons in front or in back of this plane go into
# either `front` or `back`
func split_polygon(polygon, coplanar_front, coplanar_back, front, back):
	var COPLANAR = 0 # all the vertices are within EPSILON distance from plane
	var FRONT = 1 # all the vertices are in front of the plane
	var BACK = 2 # all the vertices are at the back of the plane
	var SPANNING = 3 # some vertices are in front, some in the back

	# Classify each point as well as the entire polygon into one of the above
	# four classes.
	var polygon_type = 0
	var vertex_locs = []
	
	var nb_vertices = len(polygon.vertices)
	for i in range(nb_vertices):
		var t = self.normal.dot(polygon.vertices[i].pos) - self.d
		var loc = -1
		if t < -EPSILON: 
			loc = BACK
		elif t > EPSILON: 
			loc = FRONT
		else: 
			loc = COPLANAR
		polygon_type |= loc
		vertex_locs.append(loc)

	# Put the polygon in the correct list, splitting it when necessary.
	if polygon_type == COPLANAR:
		if self.normal.dot(polygon.plane.normal) > 0:
			coplanar_front.append(polygon)
		else:
			coplanar_back.append(polygon)
	elif polygon_type == FRONT:
		front.append(polygon)
	elif polygon_type == BACK:
		back.append(polygon)
	elif polygon_type == SPANNING:
		var f = []
		var b = []
		for i in range(nb_vertices):
			var j = (i+1) % nb_vertices
			var ti = vertex_locs[i]
			var tj = vertex_locs[j]
			var vi = polygon.vertices[i]
			var vj = polygon.vertices[j]
			if ti != BACK: 
				f.append(vi)
			if ti != FRONT:
				if ti != BACK: 
					b.append(vi.clone())
				else:
					b.append(vi)
			if (ti | tj) == SPANNING:
				# interpolation weight at the intersection point
				var t = (self.d - self.normal.dot(vi.pos)) / self.normal.dot(vj.pos - vi.pos)
				# intersection point on the plane
				var v = vi.interpolate(vj, t)
				f.append(v)
				b.append(v.clone())
		if len(f) >= 3: 
			var poly = poly_script.new().init(f, polygon.shared)
			front.append(poly)
		if len(b) >= 3: 
			var poly = poly_script.new().init(b, polygon.shared)
			back.append(poly)
