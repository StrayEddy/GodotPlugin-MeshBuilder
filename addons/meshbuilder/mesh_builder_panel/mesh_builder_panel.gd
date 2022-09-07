@tool
extends Control
class_name MeshBuilderPanel

var mesh_builder :MeshBuilder

func add_shape_creation_button(parent :Control, label_text :String, on_pressed :Callable):
	var button = ShapeCreationButton.new()
	parent.add_child(button, true)
	parent.move_child(button, 0)
	button.owner = self
	button.setup(label_text, on_pressed)
	return button

func _on_community_visibility_changed():
	if $TabContainer/Community.visible:
		var on_completed = func(complex_shapes):
			for child in $TabContainer/Community/HBoxContainer.get_children():
				if child.name != "Publish" and child.name != "Finalize":
					child.queue_free()
			
			for complex_shape in complex_shapes:
				var callable :Callable = Callable(self, "_on_add_shape_pressed")
				var button = add_shape_creation_button($TabContainer/Community/HBoxContainer, complex_shape.keys()[0], callable.bind(complex_shape))
				mesh_builder.get_image(complex_shape.keys()[0], button.setup_image)
		
		mesh_builder.get_community_meshes(on_completed)

func _on_add_shape_pressed(complex_shape):
	for shape_info in complex_shape[complex_shape.keys()[0]]:
		var shape :MeshBuilderShape
		var params :Array = shape_info.params
		params.append(shape_info.operation)
		if "Cone" in shape_info.name:
			shape = mesh_builder.add_cone(params)
		elif "Cube" in shape_info.name:
			shape = mesh_builder.add_cube(params)
		elif "Cylinder" in shape_info.name:
			shape = mesh_builder.add_cylinder(params)
		elif "DoubleCone" in shape_info.name:
			shape = mesh_builder.add_double_cone(params)
		elif "HalfSphere" in shape_info.name:
			shape = mesh_builder.add_half_sphere(params)
		elif "Ring" in shape_info.name:
			shape = mesh_builder.add_ring(params)
		elif "Sphere" in shape_info.name:
			shape = mesh_builder.add_sphere(params)
		elif "Torus" in shape_info.name:
			shape = mesh_builder.add_torus(params)
		
		shape.position = Vector3(shape_info.position[0], shape_info.position[1], shape_info.position[2])
		shape.rotation = Vector3(shape_info.rotation[0], shape_info.rotation[1], shape_info.rotation[2])
		shape.scale = Vector3(shape_info.scale[0], shape_info.scale[1], shape_info.scale[2])

func _on_add_cone_pressed():
	mesh_builder.add_cone()

func _on_add_double_cone_pressed():
	mesh_builder.add_double_cone()

func _on_add_cube_pressed():
	mesh_builder.add_cube()

func _on_add_cylinder_pressed():
	mesh_builder.add_cylinder()

func _on_add_sphere_pressed():
	mesh_builder.add_sphere()

func _on_add_half_sphere_pressed():
	mesh_builder.add_half_sphere()

func _on_add_torus_pressed():
	mesh_builder.add_torus()

func _on_add_ring_pressed():
	mesh_builder.add_ring()

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