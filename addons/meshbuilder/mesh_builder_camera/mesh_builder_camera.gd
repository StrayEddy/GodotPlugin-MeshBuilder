@tool
extends Camera3D
class_name MeshBuilderCamera

func focus_camera_on_node(node: CSGShape3D, margin = 0.9) -> void:
	var fov = self.fov
	var max_extent =  node.get_aabb().get_longest_axis_size()
	var min_distance = (max_extent * margin) / sin(deg_to_rad(fov / 2.0))
	
	var highest_point = node.get_aabb().get_center()
	for i in 8:
		var point = node.get_aabb().get_endpoint(i)
		if point.y > highest_point.y:
			highest_point = point
	
	self.global_position = Vector3(-3.0, highest_point.y + 0.5,-3.0)
	
	var offset = (self.global_position - node.global_position).normalized()
	self.global_position = node.global_position + (offset * min_distance)
	self.look_at(node.get_aabb().get_center(), Vector3.UP)
