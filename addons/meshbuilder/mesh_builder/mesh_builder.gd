@tool
extends MeshInstance3D
class_name MeshBuilder

var mesh_builder_communicator_script = load("res://addons/meshbuilder/mesh_builder/mesh_builder_communication.gd")
var mesh_builder_communicator
var root :Node3D
var csg :CSG
var nb_children = 0

var last_time_published = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh_builder_communicator = mesh_builder_communicator_script.new()
	add_child(mesh_builder_communicator, true)
	mesh_builder_communicator.owner = root
	mesh_builder_communicator.read_json_completed.connect(self.json_read)
	mesh_builder_communicator.publish_json_completed.connect(self.json_published)
	mesh_builder_communicator.read_json()

func json_read(json_data):
	print(json_data)

func json_published():
	OS.alert("Thank you for publishing your work. It will be reviewed before becoming available to the general public.")

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
func add_double_cone():
	add_shape(MeshBuilderDoubleCone.new(), "DoubleCone")
func add_cube():
	add_shape(MeshBuilderCube.new(), "Cube")
func add_cylinder():
	add_shape(MeshBuilderCylinder.new(), "Cylinder")
func add_sphere():
	add_shape(MeshBuilderSphere.new(), "Sphere")
func add_half_sphere():
	add_shape(MeshBuilderHalfSphere.new(), "HalfSphere")
func add_torus():
	add_shape(MeshBuilderTorus.new(), "Torus")
func add_ring():
	add_shape(MeshBuilderRing.new(), "Ring")

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
		if get_child(i) is MeshBuilderShape:
			var child :MeshBuilderShape = get_child(i)
			match child.operation:
				MeshBuilderShape.OPERATION_TYPE.Union:
					union(child)
				MeshBuilderShape.OPERATION_TYPE.Subtract:
					subtract(child)
				MeshBuilderShape.OPERATION_TYPE.Intersect:
					intersect(child)
	build_mesh()

func publish_check():
	if get_child_count() < 3:
		OS.alert("You need at least 2 shapes to publish your work")
		return false
	elif Time.get_ticks_msec() - last_time_published < 60000:
		OS.alert("You need to wait a minute before publishing again")
		return false
	else:
		return true

func publish():
		mesh_builder_communicator.publish(self)
		last_time_published = Time.get_ticks_msec()
