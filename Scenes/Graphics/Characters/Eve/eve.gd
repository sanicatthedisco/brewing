extends Character

func _ready():
	pre_order_dialog = Dialog.new([
		DLine.new("..."),
		DLine.new("(She seems a bit creepy.)", "protag"),
		DLine.new("Hello"),
		DLine.new("(What is she trying to say)", "protag"),
		DLine.new("I want a lemon delight."),
		DLine.new("Ok", "protag"),
		DLine.new("It seems I can’t even get a good coffee in death."),
		DLine.new("What do you mean?", "protag"),
		DLine.new("I’ll explain. Make my drink first"),
		DLine.new("Have you not noticed? Everyone here is dead."),
		DLine.new("(Looking back, everyone was a little weird)", "protag"),
		DLine.new("(What was up with the weird letters?) ", "protag"),
		DLine.new("(And the sirens I heard when I woke up.) ", "protag"),
	])

	evaluation_dialogs = {
		0.0: Dialog.new([DLine.new("This is horrendous.")]),
		0.5: Dialog.new([DLine.new("Not up to par")]),
		0.9: Dialog.new([DLine.new("This is good. Thanks")]),
	}
	
	incorrect_garnish_dialog = Dialog.new([
		DLine.new("How can a lemon delight possibly be delightful..."),
		DLine.new("Without the lemon?")
	])
	
	small_amount_dialog = Dialog.new([
		DLine.new("Are you trying to scam me here?"),
		DLine.new("At least get smaller cups.")
	])
	
	order = Order.new(
	8,
	{
		Ingredients.ESPRESSO: 1,
		Ingredients.MILK: 1,
		Ingredients.BLOOD: 1
	},
	"lemon"
)
