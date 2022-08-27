@tool
extends EditorPlugin

var plugin_button :PluginButton

func selection_changed() -> void:
	var selection = get_editor_interface().get_selection().get_selected_nodes()
	
	var is_ok = selection.size() == 1 and selection[0] is MeshInstance3D
	if is_ok:
		var root = get_tree().get_edited_scene_root()
		plugin_button.show_button(root, selection[0])
	else:
		plugin_button.hide_button()

# Create whole plugin
func _enter_tree():
	# Add button to 3D scene UI
	# Shows panel when toggled
	plugin_button = preload("res://addons/meshbuilder/plugin_button.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, plugin_button)
	plugin_button.hide()
	
	# Spy on event when object selected in tree changes
	get_editor_interface().get_selection().selection_changed.connect(self.selection_changed)

# Destroy whole plugin
func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, plugin_button)
	if plugin_button:
		plugin_button.free()
