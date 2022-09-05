@tool
extends MeshInstance3D
class_name MeshBuilder

signal shapes_received

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
	mesh_builder_communicator.read_json_completed.connect(self.read_json_completed)
	mesh_builder_communicator.publish_json_completed.connect(self.publish_json_completed)

func read_json_completed(json_data):
	emit_signal("shapes_received", json_data)

func publish_json_completed():
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

func add_cone(params :Array = [1.0,1.0,16,0]):
	var shape = MeshBuilderCone.new(params)
	add_shape(shape, "Cone")
	return shape
func add_double_cone(params :Array = [1.0,1.0,16,0]):
	var shape = MeshBuilderDoubleCone.new(params)
	add_shape(shape, "DoubleCone")
	return shape
func add_cube(params :Array = [0]):
	var shape = MeshBuilderCube.new(params)
	add_shape(shape, "Cube")
	return shape
func add_cylinder(params :Array = [1.0,1.0,1.0,16,0]):
	var shape = MeshBuilderCylinder.new(params)
	add_shape(shape, "Cylinder")
	return shape
func add_sphere(params :Array = [12,6,0]):
	var shape = MeshBuilderSphere.new(params)
	add_shape(shape, "Sphere")
	return shape
func add_half_sphere(params :Array = [12,3,0]):
	var shape = MeshBuilderHalfSphere.new(params)
	add_shape(shape, "HalfSphere")
	return shape
func add_torus(params :Array = [0.5,1.0,8,6,0]):
	var shape = MeshBuilderTorus.new(params)
	add_shape(shape, "Torus")
	return shape
func add_ring(params :Array = [1.0,0.5,1.0,16,0]):
	var shape = MeshBuilderRing.new(params)
	add_shape(shape, "Ring")
	return shape

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
			
			if not child.is_connected("csg_change", update):
				child.csg_change.connect(update)
			match child.operation:
				MeshBuilderShape.OPERATION_TYPE.Union:
					union(child)
				MeshBuilderShape.OPERATION_TYPE.Subtract:
					subtract(child)
				MeshBuilderShape.OPERATION_TYPE.Intersect:
					intersect(child)
	build_mesh()

func get_community_meshes():
	mesh_builder_communicator.read_json()

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

func finalize():
	var mesh_instance_3D = MeshInstance3D.new()
	mesh_instance_3D.mesh = mesh.duplicate(true)
	get_parent().add_child(mesh_instance_3D, true)
	mesh_instance_3D.owner = get_tree().get_edited_scene_root()
	queue_free()
