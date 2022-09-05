@tool
extends EditorPlugin

var mesh_builder_panel :MeshBuilderPanel
var editable = false

func selection_changed() -> void:
	var selection = get_editor_interface().get_selection().get_selected_nodes()
	if selection.size() == 1 and selection[0] is MeshBuilder:
		mesh_builder_panel.show()
		mesh_builder_panel.mesh_builder = selection[0]
		mesh_builder_panel.mesh_builder.root = get_tree().get_edited_scene_root()
		editable = false
	elif selection.size() == 1 and selection[0] is MeshBuilderShape:
		editable = true 
	else:
		editable = false
		mesh_builder_panel.hide()

# Override functions to capture mouse events when painting an object
func _handles(obj) -> bool:
	return editable
#
## Consumes InputEventMouseMotion and forwards other InputEvent types.
#func _forward_3d_gui_input(camera, event):
#	if event is InputEventKey:
#		print(OS.get_keycode_string(event.get_keycode_with_modifiers()))
#	return EditorPlugin.AFTER_GUI_INPUT_STOP

# Create whole plugin
func _enter_tree():
	mesh_builder_panel = preload("res://addons/meshbuilder/mesh_builder/mesh_builder_panel.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, mesh_builder_panel)
	mesh_builder_panel.hide()

	add_custom_type("MeshBuilder", "MeshBuilder", preload("res://addons/meshbuilder/mesh_builder/mesh_builder.gd"), preload("res://addons/meshbuilder/mesh_builder/icon.svg"))
	
	add_custom_type("MeshBuilderCone", "MeshBuilderCone", preload("res://addons/meshbuilder/mesh_builder_cone/mesh_builder_cone.gd"), preload("res://addons/meshbuilder/mesh_builder_cone/icon.svg"))
	add_custom_type("MeshBuilderCube", "MeshBuilderCube", preload("res://addons/meshbuilder/mesh_builder_cube/mesh_builder_cube.gd"), preload("res://addons/meshbuilder/mesh_builder_cube/icon.svg"))
	add_custom_type("MeshBuilderCylinder", "MeshBuilderCylinder", preload("res://addons/meshbuilder/mesh_builder_cylinder/mesh_builder_cylinder.gd"), preload("res://addons/meshbuilder/mesh_builder_cylinder/icon.svg"))
	add_custom_type("MeshBuilderDoubleCone", "MeshBuilderDoubleCone", preload("res://addons/meshbuilder/mesh_builder_double_cone/mesh_builder_double_cone.gd"), preload("res://addons/meshbuilder/mesh_builder_double_cone/icon.svg"))
	add_custom_type("MeshBuilderHalfSphere", "MeshBuilderHalfSphere", preload("res://addons/meshbuilder/mesh_builder_half_sphere/mesh_builder_half_sphere.gd"), preload("res://addons/meshbuilder/mesh_builder_half_sphere/icon.svg"))
	add_custom_type("MeshBuilderRing", "MeshBuilderRing", preload("res://addons/meshbuilder/mesh_builder_ring/mesh_builder_ring.gd"), preload("res://addons/meshbuilder/mesh_builder_ring/icon.svg"))
	add_custom_type("MeshBuilderSphere", "MeshBuilderSphere", preload("res://addons/meshbuilder/mesh_builder_sphere/mesh_builder_sphere.gd"), preload("res://addons/meshbuilder/mesh_builder_sphere/icon.svg"))
	add_custom_type("MeshBuilderTorus", "MeshBuilderTorus", preload("res://addons/meshbuilder/mesh_builder_torus/mesh_builder_torus.gd"), preload("res://addons/meshbuilder/mesh_builder_torus/icon.svg"))

	# Spy on event when object selected in tree changes
	get_editor_interface().get_selection().selection_changed.connect(self.selection_changed)


# Destroy whole plugin
func _exit_tree():
	remove_custom_type("MeshBuilder")
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, mesh_builder_panel)
	if mesh_builder_panel:
		mesh_builder_panel.free()
