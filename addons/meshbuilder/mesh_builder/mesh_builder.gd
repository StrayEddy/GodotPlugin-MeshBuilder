@tool
extends MeshInstance3D
class_name MeshBuilder
var root :Node3D
var csg :CSG
var nb_children = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nb_children != get_child_count():
		nb_children = get_child_count()
		update()

func union(mbs :MeshBuilderShape):
	if self.csg == null:
		self.csg = mbs.csg
	else:
		self.csg = self.csg.union(mbs.csg)

func subtract(mbs :MeshBuilderShape):
	if self.csg == null:
		self.csg = mbs.csg
	else:
		self.csg = self.csg.subtract(mbs.csg)

func intersect(mbs :MeshBuilderShape):
	if self.csg == null:
		self.csg = mbs.csg
	else:
		self.csg = self.csg.intersect(mbs.csg)

func add_shape(mbs :MeshBuilderShape, name :String):
	mbs.csg_change.connect(update)
	mbs.name = name
	add_child(mbs, true)
	mbs.owner = root
	update()

func add_cone():
	add_shape(MeshBuilderCone.new(), "Cone")
func add_cube():
	add_shape(MeshBuilderCube.new(), "Cube")
func add_cylinder():
	add_shape(MeshBuilderCylinder.new(), "Cylinder")
func add_sphere():
	add_shape(MeshBuilderSphere.new(), "Sphere")
func add_torus():
	add_shape(MeshBuilderTorus.new(), "Torus")

func build_mesh():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var start_time = Time.get_ticks_msec()
	
	var real_poly_count = 0
	if self.csg != null:
		for poly in self.csg.polygons:
			var vertices = []
			for vert in poly.vertices:
				vertices.append(vert.clone())
			vertices.reverse()
	#		var vertices :Array = poly.vertices.duplicate(true)
	#		vertices.reverse()
			for i in len(vertices)-2:
				st.add_vertex(vertices[0].pos)
				st.add_vertex(vertices[i+1].pos)
				st.add_vertex(vertices[i+2].pos)
				st.set_smooth_group(real_poly_count)
				real_poly_count += 1
	
	st.index()
	st.generate_normals()
	self.mesh = st.commit()

func update():
	csg = null
	for i in get_child_count():
		var child :MeshBuilderShape = get_child(i)
		match child.operation:
			MeshBuilderShape.OPERATION_TYPE.Union:
				union(child)
			MeshBuilderShape.OPERATION_TYPE.Subtract:
				subtract(child)
			MeshBuilderShape.OPERATION_TYPE.Intersect:
				intersect(child)
	build_mesh()
