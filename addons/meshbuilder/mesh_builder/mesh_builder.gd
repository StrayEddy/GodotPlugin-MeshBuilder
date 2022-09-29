@tool
extends CSGCombiner3D
class_name MeshBuilder
@icon("res://addons/meshbuilder/mesh_builder/icon.svg")

var mesh_builder_communicator_script = load("res://addons/meshbuilder/mesh_builder_communicator/mesh_builder_communicator.gd")
var mesh_builder_communicator
var root :Node3D
var total_nb_shapes = 0
var last_time_published = 0

var mesh_builder_camera_scene = preload("res://addons/meshbuilder/mesh_builder_camera/mesh_builder_camera.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_edited_scene_root()
	layers = 524288
	mesh_builder_communicator = mesh_builder_communicator_script.new()
	mesh_builder_communicator.name = "MeshBuilderCommunicator"
	add_child(mesh_builder_communicator, true, Node.INTERNAL_MODE_FRONT)

func publish_json_completed():
	OS.alert("Thank you for publishing your work. It will be reviewed before becoming available to the general public.")

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

static func add_shape(root :Node3D, parent :CSGShape3D, mbs :CSGShape3D, name :String):
	# Add shape under selected node (combiner or builder)
	mbs.name = name
	parent.add_child(mbs, true)
	mbs.owner = root

static func add_combiner(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCombiner.new().init()
	else:
		shape = MeshBuilderCombiner.new().init(params)
	add_shape(root, parent, shape, "Combiner")
	return shape
static func add_polygon(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderPolygon.new().init()
	else:
		shape = MeshBuilderPolygon.new().init(params)
	add_shape(root, parent, shape, "Polygon")
	return shape
static func add_cone(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCone.new().init()
	else:
		shape = MeshBuilderCone.new().init(params)
	add_shape(root, parent, shape, "Cone")
	return shape
static func add_box(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderBox.new().init()
	else:
		shape = MeshBuilderBox.new().init(params)
	add_shape(root, parent, shape, "Box")
	return shape
static func add_cylinder(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderCylinder.new().init()
	else:
		shape = MeshBuilderCylinder.new().init(params)
	add_shape(root, parent, shape, "Cylinder")
	return shape
static func add_ring(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderRing.new().init()
	else:
		shape = MeshBuilderRing.new().init(params)
	add_shape(root, parent, shape, "Ring")
	return shape
static func add_sphere(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderSphere.new().init()
	else:
		shape = MeshBuilderSphere.new().init(params)
	add_shape(root, parent, shape, "Sphere")
	return shape
static func add_torus(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderTorus.new().init()
	else:
		shape = MeshBuilderTorus.new().init(params)
	add_shape(root, parent, shape, "Torus")
	return shape
static func add_icosphere(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderIcosphere.new().init()
	else:
		shape = MeshBuilderIcosphere.new().init(params)
	add_shape(root, parent, shape, "Icosphere")
	return shape
static func add_buckyball(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderBuckyball.new().init()
	else:
		shape = MeshBuilderBuckyball.new().init(params)
	add_shape(root, parent, shape, "Buckyball")
	return shape
static func add_mesh(root :Node3D, parent :CSGShape3D, params :Array = []):
	var shape
	if params.is_empty():
		shape = MeshBuilderMesh.new().init()
	else:
		shape = MeshBuilderMesh.new().init(params)
	add_shape(root, parent, shape, "Mesh")
	return shape

func get_community_meshes(on_completed :Callable):
	mesh_builder_communicator.read_json(on_completed)

func publish_check():
	if get_all_children(self).size() < 2:
		OS.alert("You need at least 2 shapes to publish your work")
		return false
	elif Time.get_ticks_msec() - last_time_published < 60000:
		OS.alert("You need to wait a minute before publishing again")
		return false
	else:
		return true

func publish(model_name :String, on_completed :Callable):
	
	var sub_viewport = SubViewport.new()
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.size_2d_override_stretch = true
	add_child(sub_viewport, true, Node.INTERNAL_MODE_FRONT)
	sub_viewport.owner = root
	
	var mesh_builder_camera = mesh_builder_camera_scene.instantiate()
	mesh_builder_camera.current = true
	sub_viewport.add_child(mesh_builder_camera, true, Node.INTERNAL_MODE_FRONT)
	mesh_builder_camera.owner = root
	
	mesh_builder_camera.focus_camera_on_node(self)
	await RenderingServer.frame_post_draw
	var tex :ViewportTexture = sub_viewport.get_texture()
	
	sub_viewport.queue_free()
	
	var image = tex.get_image()
	image.resize(100,100)
	var image_base64 = Marshalls.raw_to_base64(image.save_png_to_buffer())
	mesh_builder_communicator.publish(self, model_name, image_base64, on_completed)
	last_time_published = Time.get_ticks_msec()

func finalize():
	var mesh_instance_3D = MeshInstance3D.new()
	var meshes = get_meshes()
	mesh_instance_3D.transform = meshes[0]
	mesh_instance_3D.mesh = meshes[1].duplicate()
	get_parent().add_child(mesh_instance_3D, true)
	mesh_instance_3D.owner = get_tree().get_edited_scene_root()
