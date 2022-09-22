@tool
extends Node
class_name MeshBuilderCommunicator

func new_httprequest(on_request_completed :Callable) -> HTTPRequest:
	var http_request :HTTPRequest = HTTPRequest.new()
	add_child(http_request, true)
	http_request.request_completed.connect(on_request_completed)
	return http_request

func publish(mesh_builder :MeshBuilder, model_name :String, image_base64 :String, on_completed :Callable):
	var shapes = []
	for child in mesh_builder.get_children():
		shapes.append(child.to_json())
	var json = {"id":str(randi()), "name":model_name, "image_base64":image_base64, "shapes":shapes}
	publish_json(json, on_completed)

func read_json(on_completed :Callable):
	var on_read_completed = func(result, response_code, headers, body):
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
		if response_code == 201:
			on_completed.call()
	var http_request = new_httprequest(on_publish_completed)
	var error = http_request.request("http://206.253.69.60:8080/publish-requests", ["content-type: application/json"], true, HTTPClient.METHOD_POST, json_string)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

