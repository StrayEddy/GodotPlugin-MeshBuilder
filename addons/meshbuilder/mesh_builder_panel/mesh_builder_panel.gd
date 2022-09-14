@tool
extends Control
class_name MeshBuilderPanel

var mesh_builder :MeshBuilder
var selected_node :Node3D
var root :Node3D

func add_shape_creation_button(parent :Control, label_text :String, image_base64 :String, on_pressed :Callable):
	var button = ShapeCreationButton.new()
	parent.add_child(button, true)
	parent.move_child(button, 0)
	button.owner = self
	button.setup(label_text, image_base64, on_pressed)
	return button

func setup_and_show(root :Node3D, selected_node :Node3D, mesh_builder :MeshBuilder):
	self.root = root
	self.selected_node = selected_node
	self.mesh_builder = mesh_builder
	self.mesh_builder.root = root
	show()

func _on_community_visibility_changed():
	if $TabContainer/Community.visible:
		var on_completed = func(shapes :Array):
			for child in $TabContainer/Community/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer.get_children():
				child.queue_free()
			
			# Sort shapes alphabetically
			shapes.sort_custom(func(a,b): return a.name > b.name)
			
			for shape in shapes:
				var callable :Callable = Callable(self, "_on_add_shape_pressed")
				var button = add_shape_creation_button($TabContainer/Community/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer, shape.name, shape.image_base64, callable.bind(selected_node, shape.shapes))
		if is_instance_valid(mesh_builder):
			mesh_builder.get_community_meshes(on_completed)

func _on_add_shape_pressed(owner_of_shapes, shapes):
	for shape_info in shapes:
		var shape :CSGShape3D
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
		
		shape.position = Vector3(shape_info.position[0], shape_info.position[1], shape_info.position[2])
		shape.rotation = Vector3(shape_info.rotation[0], shape_info.rotation[1], shape_info.rotation[2])
		shape.scale = Vector3(shape_info.scale[0], shape_info.scale[1], shape_info.scale[2])
		_on_add_shape_pressed(shape, shape_info.children)

func _on_add_combiner_pressed():
	MeshBuilder.add_combiner(root, selected_node)

func _on_add_polygon_pressed():
	MeshBuilder.add_polygon(root, selected_node)

func _on_add_cone_pressed():
	MeshBuilder.add_cone(root, selected_node)

func _on_add_box_pressed():
	MeshBuilder.add_box(root, selected_node)

func _on_add_cylinder_pressed():
	MeshBuilder.add_cylinder(root, selected_node)

func _on_add_half_sphere_pressed():
	var sphere = MeshBuilder.add_sphere(root, selected_node)
	var box = MeshBuilder.add_box(root, sphere, [[1,1,1],2])
	box.position.y -= .5

func _on_add_sphere_pressed():
	MeshBuilder.add_sphere(root, selected_node)

func _on_add_ring_pressed():
	var cylinder = MeshBuilder.add_cylinder(root, selected_node)
	MeshBuilder.add_cylinder(root, cylinder, [false,2.0,0.25,8,true,2])

func _on_add_torus_pressed():
	MeshBuilder.add_torus(root, selected_node)

func _on_publish_pressed():
	if mesh_builder.publish_check():
		$ConfirmationDialog.dialog_text = "Do you really want to publish your MeshBuilder shape, and make it available for anyone to use ?"
		$ConfirmationDialog.popup_centered()

func _on_confirmation_dialog_confirmed():
	var on_completed = func():
		OS.alert("Thank you for publishing your work. It will be reviewed before becoming available to the general public.")
	mesh_builder.publish(on_completed)

func _on_finalize_pressed():
	mesh_builder.finalize()
	mesh_builder.queue_free()

# When search bar text changes
func _on_line_edit_text_changed(new_text):
	for button in $TabContainer/Community/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer.get_children():
		if new_text in button.label.text or new_text == "":
			button.show()
		else:
			button.hide()
