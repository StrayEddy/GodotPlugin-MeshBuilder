@tool
extends Node
class_name MeshBuilderCommunication

func new_httprequest(on_request_completed :Callable) -> HTTPRequest:
	var http_request :HTTPRequest = HTTPRequest.new()
	add_child(http_request, true)
	http_request.request_completed.connect(on_request_completed)
	return http_request

func publish(mesh_builder :MeshBuilder, on_completed :Callable):
	var simple_shapes_array = []
	for i in mesh_builder.get_child_count():
		if mesh_builder.get_child(i) is MeshBuilderShape:
			var child :MeshBuilderShape = mesh_builder.get_child(i)
			simple_shapes_array.append({
				"name": child.name,
				"operation": child.operation,
				"scale": [child.scale.x, child.scale.y, child.scale.z],
				"rotation": [child.rotation.x, child.rotation.y, child.rotation.z],
				"position": [child.position.x, child.position.y, child.position.z],
				"params": child.current_values,
			})
	var new_json = {"id":str(randi()), "shapes": simple_shapes_array}
	
	publish_json(new_json, on_completed)

func read_json(on_completed :Callable):
	var on_read_completed = func(result, response_code, headers, body):
		print(response_code)
		if response_code == 200:
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			on_completed.call(json.get_data())
	var http_request = new_httprequest(on_read_completed)
	var error = http_request.request("http://206.253.69.60:8080/shapes", [])
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func publish_json(json_data :Dictionary, on_completed :Callable):
	var json_string = JSON.new().stringify(json_data)
	var on_publish_completed = func(result, response_code, headers, body):
		print(response_code)
		if response_code == 201:
			on_completed.call()
	var http_request = new_httprequest(on_publish_completed)
	var error = http_request.request("http://206.253.69.60:8080/publish-requests", ["content-type: application/json"], true, HTTPClient.METHOD_POST, json_string)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func get_image(image_name :String, on_completed :Callable):
	var on_get_completed = func(result, response_code, headers, body, on_completed):
		print(response_code)
		if response_code == 200:
			var image = Image.new()
			var image_error = image.load_png_from_buffer(body)
			on_completed.call(image)
	var http_request = new_httprequest(on_get_completed.bind(on_completed))
	var error = http_request.request("http://206.253.69.60:8080/assets/images/" + image_name + ".png", [])
	if error != OK:
		push_error("An error occurred in the HTTP request.")

