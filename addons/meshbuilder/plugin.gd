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
		editable = true
	else:
		editable = false
		mesh_builder_panel.hide()

# Override functions to capture mouse events when painting an object
func _handles(obj) -> bool:
	return editable

# Create whole plugin
func _enter_tree():
	mesh_builder_panel = preload("res://addons/meshbuilder/mesh_builder/mesh_builder_panel.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, mesh_builder_panel)
	mesh_builder_panel.hide()

	add_custom_type("MeshBuilder", "MeshBuilder", preload("res://addons/meshbuilder/mesh_builder/mesh_builder.gd"), preload("res://addons/meshbuilder/mesh_builder/icon.png"))
	
	add_custom_type("MeshBuilderCone", "MeshBuilderShape", preload("res://addons/meshbuilder/mesh_builder_cone/mesh_builder_cone.gd"), preload("res://addons/meshbuilder/mesh_builder_cone/icon.png"))

	# Spy on event when object selected in tree changes
	get_editor_interface().get_selection().selection_changed.connect(self.selection_changed)


# Destroy whole plugin
func _exit_tree():
	remove_custom_type("MeshBuilder")
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_BOTTOM, mesh_builder_panel)
	if mesh_builder_panel:
		mesh_builder_panel.free()
