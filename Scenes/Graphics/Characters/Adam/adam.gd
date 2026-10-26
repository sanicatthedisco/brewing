extends Character

func _ready():
	pre_order_dialog = Dialog.new([
		DLine.new("Could I have an iced latte please?"),
		DLine.new("?", "protag"),
		DLine.new("Oh, sorry. That’s just what I usually order."),
		DLine.new("What do you guys have? I overslept and my mind’s a mess…"),
		DLine.new("I have to clock in in 20 minutes."),
		DLine.new("No worries. I just woke up from a nap myself.", "protag"),
		DLine.new("The menu’s to your left.", "protag"),
		DLine.new("Hmm…"),
		DLine.new("Then I’ll have a cool energy espresso.")
	])

	
	evaluation_dialogs = {
		0.0: Dialog.new([DLine.new("This isn’t what I wanted at all.")]),
		0.5: Dialog.new([DLine.new("It’s okay…")]),
		0.9: Dialog.new([DLine.new("Thank you, I have energy now.")]),
	}
	
	order = Order.new(
	8,
	{
		Ingredients.ESPRESSO: 1,
		Ingredients.WATER: 3
	},
	"electric_star"
)
