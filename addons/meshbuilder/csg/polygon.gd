@tool
extends Node
class_name Polygon

var vertices = []
var shared = []
var plane

# class Polygon
# Represents a convex polygon. The vertices used to initialize a polygon must
# be coplanar and form a convex loop. They do not have to be `Vertex`
# instances but they must behave similarly (duck typing can be used for
# customization).
#
# Each convex polygon has a `shared` property, which is shared between all
# polygons that are clones of each other or were split from the same polygon.
# This can be used to define per-polygon properties (such as surface color).

func init(vertices :Array, shared=null):
	self.vertices = vertices
	self.shared = shared
	self.plane = MyPlane.from_points(vertices[0].pos, vertices[1].pos, vertices[2].pos)
	return self

func clone():
	var poly = Polygon.new().init(self.vertices.duplicate(true), self.shared.duplicate(true))
	return poly

func flip():
	self.vertices.reverse()
	for vert in self.vertices:
		vert.flip()
	self.plane.flip()
