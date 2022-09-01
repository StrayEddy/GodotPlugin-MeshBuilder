@tool
extends Node
class_name MeshBuilderCommunication

signal read_json_completed
signal publish_json_completed

var waiting_to_read = false
var httpRequest :HTTPRequest = HTTPRequest.new()

# Called when the node enters the scene tree for the first time.
func _init():
	add_child(httpRequest, true)
	httpRequest.request_completed.connect(self._on_request_completed)

func read_json():
	waiting_to_read = true
	var error = httpRequest.request("http://206.253.69.60:8080/shapes", [])
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func publish(mesh_builder :MeshBuilder):
	var simple_shapes_array = []
	for i in mesh_builder.get_child_count():
		if mesh_builder.get_child(i) is MeshBuilderShape:
			var child :MeshBuilderShape = mesh_builder.get_child(i)
			simple_shapes_array.append({
				"name": child.name,
				"operation": child.operation,
				"scale": child.scale,
				"rotation": child.rotation,
				"position": child.position + Vector3(3,0,0),
				"params": child.current_values,
			})
	var new_json = {"id":str(randi()), "shapes": simple_shapes_array}
	
	publish_json(new_json)

func publish_json(json_data :Dictionary):
	var json_string = JSON.new().stringify(json_data)
	var error = httpRequest.request("http://206.253.69.60:8080/publish-requests", ["content-type: application/json"], true, HTTPClient.METHOD_POST, json_string)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _on_request_completed(result, response_code, headers, body):
	print(response_code)
	if response_code == 200 and waiting_to_read:
		waiting_to_read = false
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		emit_signal("read_json_completed", json.get_data())
	elif response_code == 201 and not waiting_to_read:
		emit_signal("publish_json_completed")
