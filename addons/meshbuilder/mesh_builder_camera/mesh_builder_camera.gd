tool
extends Camera
class_name MeshBuilderCamera

func focus_camera_on_node(node: CSGShape, margin = 0.9) -> void:
	var fov = self.fov
	var max_extent =  node.get_aabb().get_longest_axis_size()
	var min_distance = (max_extent * margin) / sin(deg2rad(fov / 2.0))
	
	var highest_point = node.get_aabb().get_center()
	for i in 8:
		var point = node.get_aabb().get_endpoint(i)
		if point.y > highest_point.y:
			highest_point = point
	
	self.global_translation = Vector3(-3.0, highest_point.y + 3.0,-3.0)
	
	var offset = (self.global_translation - node.global_translation).normalized()
	self.global_translation = node.global_translation + (offset * min_distance)
	self.look_at(node.get_aabb().get_center(), Vector3.UP)
