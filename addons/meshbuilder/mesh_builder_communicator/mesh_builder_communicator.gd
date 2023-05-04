@tool
extends Node
class_name MeshBuilderCommunicator

const json_file = "res://addons/meshbuilder/myshapes.json"

func publish(mesh_builder :MeshBuilder, model_name :String, image_base64 :String, on_completed :Callable):
	var shapes = []
	for child in mesh_builder.get_children():
		shapes.append(child.to_json())
	var new_shape = {"id":str(randi()), "name":model_name, "image_base64":image_base64, "shapes":shapes}
	add_shape_to_json(new_shape, on_completed)

func read_json(on_completed :Callable):
	var file = FileAccess.open(json_file, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	json.parse(content)
	on_completed.call(json.data)

func write_json(content):
	var file = FileAccess.open(json_file, FileAccess.WRITE)
	file.store_string(content)

func add_shape_to_json(new_shape :Dictionary, on_completed :Callable):
	var json_as_text = FileAccess.get_file_as_string(json_file)
	var json = JSON.parse_string(json_as_text)
	json.append(new_shape)
	var new_json_string = JSON.new().stringify(json)
	write_json(new_json_string)

