tool
extends Control
class_name MeshBuilderPanel

var mesh_builder :MeshBuilder
var selected_node :Spatial
var root :Spatial

func add_shape_creation_button(parent :Control, label_text :String, image_base64 :String, on_pressed :Callable):
	var button = ShapeCreationButton.new()
	parent.add_child(button, true)
	parent.move_child(button, 0)
	button.owner = self
	button.setup(label_text, image_base64, on_pressed)
	return button

func setup_and_show(root :Spatial, selected_node :Spatial, mesh_builder :MeshBuilder):
	self.root = root
	self.selected_node = selected_node
	self.mesh_builder = mesh_builder
	self.mesh_builder.root = root
	show()

func _on_community_visibility_changed():
	if $TabContainer/MyShapes.visible:
		var on_completed = Callable.new()
		on_completed.setup(self, "_callable_on_community_visibility_changed")
		if is_instance_valid(mesh_builder):
			mesh_builder.get_community_meshes(on_completed)

func _callable_on_community_visibility_changed(shapes :Array):
	for child in $TabContainer/MyShapes/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer.get_children():
		child.queue_free()
	
	# Sort shapes alphabetically
	shapes.sort_custom(self, "sort_shapes_alphabetically")
	
	for shape in shapes:
		var callable = Callable.new()
		callable.setup(self, "_on_add_shape_pressed", [selected_node, shape.shapes])
		var button = add_shape_creation_button($TabContainer/MyShapes/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer, shape.name, shape.image_base64, callable)

static func sort_shapes_alphabetically(a, b):
	return a.name > b.name

func _on_add_shape_pressed(owner_of_shapes, shapes):
	for shape_info in shapes:
		var shape :CSGShape
		var params :Array = shape_info.params
		if "Combiner" in shape_info.name:
			shape = MeshBuilder.add_combiner(root, owner_of_shapes, params)
		elif "Polygon" in shape_info.name:
			shape = MeshBuilder.add_polygon(root, owner_of_shapes, params)
		elif "Cone" in shape_info.name:
			shape = MeshBuilder.add_cone(root, owner_of_shapes, params)
		elif "Box" in shape_info.name:
			shape = MeshBuilder.add_box(root, owner_of_shapes, params)
		elif "Cylinder" in shape_info.name:
			shape = MeshBuilder.add_cylinder(root, owner_of_shapes, params)
		elif "Sphere" in shape_info.name:
			shape = MeshBuilder.add_sphere(root, owner_of_shapes, params)
		elif "Torus" in shape_info.name:
			shape = MeshBuilder.add_torus(root, owner_of_shapes, params)
		elif "Icosphere" in shape_info.name:
			shape = MeshBuilder.add_icosphere(root, owner_of_shapes, params)
		elif "Buckyball" in shape_info.name:
			shape = MeshBuilder.add_buckyball(root, owner_of_shapes, params)
		elif "Ring" in shape_info.name:
			shape = MeshBuilder.add_ring(root, owner_of_shapes, params)
		elif "Mesh" in shape_info.name:
			shape = MeshBuilder.add_mesh(root, owner_of_shapes, params)
		
		if shape_info.has("position"):
			shape.position = Vector3(shape_info.position[0], shape_info.position[1], shape_info.position[2])
		if shape_info.has("rotation"):
			shape.rotation = Vector3(shape_info.rotation[0], shape_info.rotation[1], shape_info.rotation[2])
		if shape_info.has("scale"):
			shape.scale = Vector3(shape_info.scale[0], shape_info.scale[1], shape_info.scale[2])
		
		_on_add_shape_pressed(shape, shape_info.children)

func _on_add_combiner_pressed():
	MeshBuilder.add_combiner(root, selected_node)

func _on_AddPolygon_pressed():
	MeshBuilder.add_polygon(root, selected_node)

func _on_AddCone_pressed():
	MeshBuilder.add_cone(root, selected_node)

func _on_AddBox_pressed():
	MeshBuilder.add_box(root, selected_node)

func _on_AddCylinder_pressed():
	MeshBuilder.add_cylinder(root, selected_node)

func _on_AddHalfSphere_pressed():
	var params = ["SphereMesh",[0.5,0.5,12,6,true],false,0]
	MeshBuilder.add_mesh(root, selected_node, params)

func _on_AddSphere_pressed():
	MeshBuilder.add_sphere(root, selected_node)

func _on_AddRing_pressed():
	MeshBuilder.add_ring(root, selected_node)

func _on_AddTorus_pressed():
	MeshBuilder.add_torus(root, selected_node)

func _on_AddIcosphere_pressed():
	MeshBuilder.add_icosphere(root, selected_node)

func _on_AddBuckyball_pressed():
	MeshBuilder.add_buckyball(root, selected_node)

func _on_AddMesh_pressed():
	MeshBuilder.add_mesh(root, selected_node)

func _on_Publish_pressed():
	if mesh_builder.publish_check():
		$ConfirmationDialog.dialog_text = "Do you really want to publish your MeshBuilder shape, and make it available for anyone to use ?"
		$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	$NameForPublishDialog.dialog_text = "How do you want to name your published model ?"
	$NameForPublishDialog.popup_centered()

func _on_NameForPublishDialog_confirmed():
	var on_completed = Callable.new()
	on_completed.setup(self, "_callable_on_name_for_publish_dialog_confirmed")
	mesh_builder.publish($NameForPublishDialog/LineEdit.text, on_completed)

func _callable_on_name_for_publish_dialog_confirmed():
	OS.alert("Thank you for publishing your work. It will be reviewed before becoming available to the general public.")

func _on_Finalize_pressed():
	mesh_builder.finalize()
	mesh_builder.queue_free()

# When search bar text changes
func _on_LineEdit_text_changed(new_text):
	for button in $TabContainer/MyShapes/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer.get_children():
		if new_text in button.label.text or new_text == "":
			button.show()
		else:
			button.hide()
