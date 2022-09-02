@tool
extends VBoxContainer
class_name ShapeCreationButton

var label :Label
var texture_rect :TextureRect
var button :Button

func init(label_text :String, texture :Texture2D, on_pressed :Callable):
	label = Label.new()
	label.text = label_text
	texture_rect = TextureRect.new()
	texture_rect.texture = texture
	button = Button.new()
	button.text = "Add"
	button.modulate = Color.GREEN
	button.pressed.connect(on_pressed)
	
	add_child(label, true)
	add_child(texture_rect, true)
	add_child(button, true)
	
	return self
