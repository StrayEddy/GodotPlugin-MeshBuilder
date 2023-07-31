tool
extends Node
class_name MeshBuilderCommunicator

const json_file = "res://addons/meshbuilder/myshapes.json"

func publish(mesh_builder, model_name :String, image_base64 :String, on_completed :Callable):
	var shapes = []
	for child in mesh_builder.get_children():
		if not child is Viewport:
			shapes.append(child.to_json())
	var new_shape = {"id":str(randi()), "name":model_name, "image_base64":image_base64, "shapes":shapes}
	add_shape_to_json(new_shape, on_completed)

func read_json(on_completed :Callable):
	var file = File.new()
	if file.open(json_file, File.READ) == OK:
		var content = file.get_as_text()
		var json = JSON.parse(content)
		on_completed.run([json.result])
	else:
		print("Failed to open file for reading.")

func write_json(content):
	var file = File.new()
	if file.open(json_file, File.WRITE) == OK:
		file.store_string(content)
		file.close()
	else:
		print("Failed to open file for writing.")

func add_shape_to_json(new_shape :Dictionary, on_completed :Callable):
	var file = File.new()
	if file.open(json_file, File.READ) == OK:
		var json_as_text = file.get_as_text()
		var json = JSON.parse(json_as_text).result
		json.append(new_shape)
		
		var new_json_string = JSON.print(json)
		write_json(new_json_string)
	else:
		print("Failed to open file for reading.")

