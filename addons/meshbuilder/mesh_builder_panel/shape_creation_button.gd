tool
extends VBoxContainer
class_name ShapeCreationButton

var label :Label
var texture_rect :TextureRect
var button :Button
var callable_on_pressed :Callable


func setup(label_text :String, image_base64 :String, callable_on_pressed :Callable):
	label = Label.new()
	label.rect_min_size = Vector2(100,50)
	label.autowrap = true
	label.text = label_text
	label.align = ALIGN_CENTER
	texture_rect = TextureRect.new()
	texture_rect.rect_min_size = Vector2(100,100)
	setup_image(image_base64)
	button = Button.new()
	button.text = "Add"
	button.modulate = Color.green
	button.connect("pressed", self, "_on_pressed")
	self.callable_on_pressed = callable_on_pressed
	
	add_child(label, true)
	add_child(texture_rect, true)
	add_child(button, true)
	return self

func _on_pressed():
	callable_on_pressed.run()

func setup_image(image_base64 :String):
	var image = Image.new()
	image.load_png_from_buffer(Marshalls.base64_to_raw(image_base64))
	var imgTex = ImageTexture.new()
	imgTex.create_from_image(image)
#	imgTex.create_from_image(image)
	texture_rect.texture = imgTex
#	texture_rect.update_minimum_size()
