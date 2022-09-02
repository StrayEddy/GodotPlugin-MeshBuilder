@tool
extends Control
class_name MeshBuilderPanel

var mesh_builder :MeshBuilder

func _on_community_visibility_changed():
	if $TabContainer/Community.visible:
		if not mesh_builder.shapes_received.is_connected(self.shapes_received):
			mesh_builder.shapes_received.connect(self.shapes_received)
		mesh_builder.get_community_meshes()

func shapes_received(shapes):
	for shape in shapes:
		print(shape)

func _on_button_pressed():
	mesh_builder.add_csg()

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
