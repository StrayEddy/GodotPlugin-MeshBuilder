@tool
extends Node
class_name Vertex

var pos :Vector3
var normal :Vector3

#    Class Vertex 
#    Represents a vertex of a polygon. Use your own vertex class instead of this
#    one to provide additional features like texture coordinates and vertex
#    colors. Custom vertex classes need to provide a `pos` property and `clone()`,
#    `flip()`, and `interpolate()` methods that behave analogous to the ones
#    defined by `Vertex`. This class provides `normal` so convenience
#    functions like `CSG.sphere()` can return a smooth vertex normal, but `normal`
#    is not used anywhere else.

### Had to change normal default from null to Vector3.ZERO
func init(pos :Vector3, normal :Vector3 = Vector3.ZERO):
	self.pos = Vector3(pos)
	self.normal = Vector3(normal)
	return self
	
func clone():
	var vert = Vertex.new()
	vert.pos = Vector3(pos)
	vert.normal = Vector3(normal)
	return vert

# Invert all orientation-specific data (e.g. vertex normal). Called when the
# orientation of a polygon is flipped.
func flip():
	normal = -normal
	return self

# Create a new vertex between this vertex and `other` by linearly
# interpolating all properties using a parameter of `t`. Subclasses should
# override this to interpolate additional properties.
func interpolate(other :Vertex, t :float):
	var vert = Vertex.new()
	vert.pos = Vector3(pos.lerp(other.pos, t))
	vert.normal = Vector3(normal.lerp(other.normal, t))
	return vert

func rotated(rotation :Vector3):
	pos = pos.rotated(Vector3.RIGHT, rotation.x)
	pos = pos.rotated(Vector3.UP, rotation.y)
	pos = pos.rotated(Vector3.BACK, rotation.z)
	return self

func translated(position :Vector3):
	pos += position
	return self
