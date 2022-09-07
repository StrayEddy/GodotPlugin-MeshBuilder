@tool
extends VBoxContainer
class_name ShapeCreationButton

var label :Label
var texture_rect :TextureRect
var button :Button


func setup(label_text :String, on_pressed :Callable):
	label = Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(100,100)
	button = Button.new()
	button.text = "Add"
	button.modulate = Color.GREEN
	button.pressed.connect(on_pressed)
	
	add_child(label, true)
	add_child(texture_rect, true)
	add_child(button, true)
	return self

func setup_image(image :Image):
	var texture = ImageTexture.create_from_image(image)
	texture.create_from_image(image)
	texture_rect.texture = texture
	texture_rect.update()
