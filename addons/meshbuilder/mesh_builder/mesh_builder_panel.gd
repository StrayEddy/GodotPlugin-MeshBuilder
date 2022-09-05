@tool
extends Control
class_name MeshBuilderPanel

var mesh_builder :MeshBuilder

func add_shape_creation_button(parent :Control, label_text :String, texture :Texture2D, on_pressed :Callable):
	var button = ShapeCreationButton.new(label_text, texture, on_pressed)
	parent.add_child(button, true)
	button.owner = self

func _on_community_visibility_changed():
	if $TabContainer/Community.visible:
		if not mesh_builder.shapes_received.is_connected(self.shapes_received):
			mesh_builder.shapes_received.connect(self.shapes_received)
		mesh_builder.get_community_meshes()

func shapes_received(complex_shapes):
	for child in $TabContainer/Community/HBoxContainer.get_children():
		if child.name != "Publish":
			child.queue_free()
	
	for complex_shape in complex_shapes:
		var callable :Callable = Callable(self, "_on_add_shape_pressed")
		add_shape_creation_button($TabContainer/Community/HBoxContainer, complex_shape.keys()[0], null, callable.bind(complex_shape))

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
	mesh_builder.publish()
