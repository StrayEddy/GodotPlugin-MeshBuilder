@tool
extends VBoxContainer
class_name ShapeCreationButton

var label :Label
var texture_rect :TextureRect
var button :Button


func setup(label_text :String, image_base64 :String, on_pressed :Callable):
	label = Label.new()
	label.custom_minimum_size = Vector2i(100,50)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(100,100)
	setup_image(image_base64)
	button = Button.new()
	button.text = "Add"
	button.modulate = Color.GREEN
	button.pressed.connect(on_pressed)
	
	add_child(label, true)
	add_child(texture_rect, true)
	add_child(button, true)
	return self

func setup_image(image_base64 :String):
	var image = Image.new()
	image.load_png_from_buffer(Marshalls.base64_to_raw(image_base64))
	var texture = ImageTexture.create_from_image(image)
	texture.create_from_image(image)
	texture_rect.texture = texture
	texture_rect.update_minimum_size()
