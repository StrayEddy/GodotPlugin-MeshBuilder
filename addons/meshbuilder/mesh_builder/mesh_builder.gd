@tool
extends MeshInstance3D
class_name MeshBuilder
@icon("res://addons/meshbuilder/mesh_builder/icon.svg")

var mesh_builder_communicator_script = load("res://addons/meshbuilder/mesh_builder/mesh_builder_communication.gd")
var mesh_builder_communicator
var root :Node3D
var nb_children = 0
var last_time_published = 0

var sub_viewport :SubViewport
var mesh_builder_camera :MeshBuilderCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh_builder_communicator = mesh_builder_communicator_script.new()
	add_child(mesh_builder_communicator, true, Node.INTERNAL_MODE_FRONT)
	mesh_builder_communicator.owner = root

	sub_viewport = SubViewport.new()
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.size_2d_override_stretch = true
	add_child(sub_viewport, true, Node.INTERNAL_MODE_FRONT)
	sub_viewport.owner = root
	
	mesh_builder_camera = MeshBuilderCamera.new()
	sub_viewport.add_child(mesh_builder_camera, true, Node.INTERNAL_MODE_FRONT)
	mesh_builder_camera.owner = root

func publish_json_completed():
	OS.alert("Thank you for publishing your work. It will be reviewed before becoming available to the general public.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nb_children != get_child_count():
		nb_children = get_child_count()
		update()

func add_shape(mbs :MeshBuilderShape, name :String, selected_node :Node3D):
	if selected_node == self or selected_node is MeshBuilderCombiner:
		# Add shape under selected node (combiner or builder)
		mbs.csg_change.connect(update)
		mbs.name = name
		selected_node.add_child(mbs, true)
		mbs.owner = root
	else:
		# Add combiner to parent
		var combiner = MeshBuilderCombiner.new()
		combiner.csg_change.connect(update)
		combiner.name = "Combiner"
		selected_node.get_parent().add_child(combiner, true)
		combiner.owner = root
		# Move selected node under combiner
		reparent(selected_node, combiner)
		combiner.operation = selected_node.operation
		selected_node.operation = MeshBuilderShape.OPERATION_TYPE.Union
		selected_node.owner = root
		# Add shape under combiner
		mbs.csg_change.connect(update)
		mbs.name = name
		combiner.add_child(mbs, true)
		mbs.owner = root

static func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func add_combiner(selected_node :Node3D):
	var combiner = MeshBuilderCombiner.new()
	combiner.csg_change.connect(update)
	combiner.name = "Combiner"
	selected_node.add_child(combiner, true)
	combiner.owner = root
	return combiner

func add_cone(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCone.new()
	else:
		shape = MeshBuilderCone.new(params)
	add_shape(shape, "Cone", selected_node)
	return shape
func add_double_cone(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderDoubleCone.new()
	else:
		shape = MeshBuilderDoubleCone.new(params)
	add_shape(shape, "DoubleCone", selected_node)
	return shape
func add_cube(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCube.new()
	else:
		shape = MeshBuilderCube.new(params)
	add_shape(shape, "Cube", selected_node)
	return shape
func add_cylinder(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCylinder.new()
	else:
		shape = MeshBuilderCylinder.new(params)
	add_shape(shape, "Cylinder", selected_node)
	return shape
func add_sphere(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderSphere.new()
	else:
		shape = MeshBuilderSphere.new(params)
	add_shape(shape, "Sphere", selected_node)
	return shape
func add_half_sphere(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderHalfSphere.new()
	else:
		shape = MeshBuilderHalfSphere.new(params)
	add_shape(shape, "HalfSphere", selected_node)
	return shape
func add_torus(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderTorus.new()
	else:
		shape = MeshBuilderTorus.new(params)
	add_shape(shape, "Torus", selected_node)
	return shape
func add_ring(selected_node :Node3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderRing.new()
	else:
		shape = MeshBuilderRing.new(params)
	add_shape(shape, "Ring", selected_node)
	return shape

func get_csg() -> CSG:
	var csg = CSG.new()
	for shape in get_children():
		if not shape is MeshBuilderShape:
			continue
		else:
			match shape.operation:
				MeshBuilderShape.OPERATION_TYPE.Union:
					csg = csg.union(shape.get_csg())
				MeshBuilderShape.OPERATION_TYPE.Subtract:
					csg = csg.subtract(shape.get_csg())
				MeshBuilderShape.OPERATION_TYPE.Intersect:
					csg = csg.intersect(shape.get_csg())
	return csg.scale(scale).rotate(rotation).translate(position)

func update():
	var csg = get_csg()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var start_time = Time.get_ticks_msec()
	
	var real_poly_count = 0
	if csg != null:
		for poly in csg.polygons:
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

func get_community_meshes(on_completed :Callable):
	mesh_builder_communicator.read_json(on_completed)

func publish_check():
	if get_child_count() < 2:
		OS.alert("You need at least 2 shapes to publish your work")
		return false
	elif Time.get_ticks_msec() - last_time_published < 60000:
		OS.alert("You need to wait a minute before publishing again")
		return false
	else:
		return true

func publish(on_completed :Callable):
	mesh_builder_camera.focus_camera_on_node(self)
	await RenderingServer.frame_post_draw
	var tex :ViewportTexture = sub_viewport.get_texture()
	var image = tex.get_image()
	image.resize(100,100)
	var image_base64 = Marshalls.raw_to_base64(image.save_png_to_buffer())
	mesh_builder_communicator.publish(self, image_base64, on_completed)
	last_time_published = Time.get_ticks_msec()

func finalize():
	var mesh_instance_3D = MeshInstance3D.new()
	mesh_instance_3D.mesh = mesh.duplicate(true)
	get_parent().add_child(mesh_instance_3D, true)
	mesh_instance_3D.owner = get_tree().get_edited_scene_root()
	queue_free()
