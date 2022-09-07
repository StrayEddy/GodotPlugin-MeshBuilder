@tool
extends Camera3D
class_name MeshBuilderCamera

func focus_camera_on_node(node: MeshInstance3D, margin = .7) -> void:
	var fov = self.fov
	var max_extent =  node.get_aabb().get_longest_axis_size()
	var min_distance = (max_extent * margin) / sin(deg2rad(fov / 2.0))
	var offset = (self.global_position - node.global_position).normalized()
	self.global_position = node.global_position + (offset * min_distance)
	self.look_at(node.get_aabb().get_center(), Vector3.UP)
