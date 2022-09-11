@tool
extends Control
class_name MeshBuilderPanel

var mesh_builder :MeshBuilder
var selected_node :Node3D

func add_shape_creation_button(parent :Control, label_text :String, image_base64 :String, on_pressed :Callable):
	var button = ShapeCreationButton.new()
	parent.add_child(button, true)
	parent.move_child(button, 0)
	button.owner = self
	button.setup(label_text, image_base64, on_pressed)
	return button

func _on_community_visibility_changed():
	if $TabContainer/Community.visible:
		var on_completed = func(shapes :Array):
			for child in $TabContainer/Community/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer.get_children():
				child.queue_free()
			
			# Sort shapes alphabetically
			shapes.sort_custom(func(a,b): return a.name > b.name)
			
			for shape in shapes:
				var callable :Callable = Callable(self, "_on_add_shape_pressed")
				var button = add_shape_creation_button($TabContainer/Community/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer, shape.name, shape.image_base64, callable.bind(shape.shapes))
		
		mesh_builder.get_community_meshes(on_completed)

func _on_add_shape_pressed(shapes):
	for shape_info in shapes:
		var shape :MeshBuilderShape
		var params :Array = shape_info.params
		params.append(shape_info.operation)
		if "Combiner" in shape_info.name:
			shape = mesh_builder.add_combiner(selected_node)
		if "Cone" in shape_info.name:
			shape = mesh_builder.add_cone(selected_node, params)
		elif "Cube" in shape_info.name:
			shape = mesh_builder.add_cube(selected_node, params)
		elif "Cylinder" in shape_info.name:
			shape = mesh_builder.add_cylinder(selected_node, params)
		elif "DoubleCone" in shape_info.name:
			shape = mesh_builder.add_double_cone(selected_node, params)
		elif "HalfSphere" in shape_info.name:
			shape = mesh_builder.add_half_sphere(selected_node, params)
		elif "Ring" in shape_info.name:
			shape = mesh_builder.add_ring(selected_node, params)
		elif "Sphere" in shape_info.name:
			shape = mesh_builder.add_sphere(selected_node, params)
		elif "Torus" in shape_info.name:
			shape = mesh_builder.add_torus(selected_node, params)
		
		shape.position = Vector3(shape_info.position[0], shape_info.position[1], shape_info.position[2])
		shape.rotation = Vector3(shape_info.rotation[0], shape_info.rotation[1], shape_info.rotation[2])
		shape.scale = Vector3(shape_info.scale[0], shape_info.scale[1], shape_info.scale[2])
		for child_shape in shape_info.children:
			_on_add_shape_pressed(child_shape)

func _on_add_cone_pressed():
	mesh_builder.add_cone(selected_node)

func _on_add_double_cone_pressed():
	mesh_builder.add_double_cone(selected_node)

func _on_add_cube_pressed():
	mesh_builder.add_cube(selected_node)

func _on_add_cylinder_pressed():
	mesh_builder.add_cylinder(selected_node)

func _on_add_sphere_pressed():
	mesh_builder.add_sphere(selected_node)

func _on_add_half_sphere_pressed():
	mesh_builder.add_half_sphere(selected_node)

func _on_add_torus_pressed():
	mesh_builder.add_torus(selected_node)

func _on_add_ring_pressed():
	mesh_builder.add_ring(selected_node)

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

# When search bar text changes
func _on_line_edit_text_changed(new_text):
	for button in $TabContainer/Community/HBoxContainer/VBoxContainer/ScrollContainer/GridContainer.get_children():
		if new_text in button.label.text or new_text == "":
			button.show()
		else:
			button.hide()
