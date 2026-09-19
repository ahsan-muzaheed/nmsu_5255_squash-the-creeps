# Godot World – Squash the Creeps (3D), Modified

1. public URL to my completed Godot World game: 
 https://ahsan-muzaheed.github.io/nmsu_5255_squash-the-creeps/



2.A zip file of my completed Godot game: Attcahed as "squash_the_creeps.zip"

3.A readme detailing what I have changed about the Dodge the Creeps game:

CSCI 4255/5255 – Godot World assignment. For this assignment I completed the Godot
https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html
tutorial (the Bonus option) using Godot v4.7.2, and then modified the game.


## What I changed and why

### The problem
In the original game, the player dies the moment any creep touches them from the side.
A first-time player does not know what is going to happen yet – before they understand
the controls or the idea of jumping on creeps, one creep runs into them and the game is over.
There is no time to learn. When I first played it, I had the same experience and could not
understand what to do before I lost.

### My changes

1. Dying is disabled.

I commented out the call to die() in the player's collision function, so touching
a creep no longer ends the game. The player can keep moving, get bumped around by
creeps, and practice jumping on them.

.\squash_the_creeps\Player.gd:

	func _on_MobDetector_body_entered(_body):
		print("Player was hit by: ", _body.name)
		##die()

Instead of dying, each collision is logged to the console: it prints the name of
the creep body the player collided with. This is visible in Godot's Output panel,
or in the browser console with F12.


2. Collisions are counted and shown on screen.

I added a new HitLabel under the score, with this function in hit_label.gd:

	func _on_player_collided():
		hits += 1
		text = "Hits: %s" % hits

Every time it is called, the count goes up by one and the new value is shown in
the label.


3. How the _on_player_collided and player collission  are connected.

.\squash_the_creeps\Player.gd also contains:

	signal collided

	func _on_MobDetector_body_entered(_body):
		.....
		collided.emit()
		.....

_on_MobDetector_body_entered() is called by MobDetector, which I think works like
a collision box around the player. I have not dug into that part yet.

When a collision happens, I call collided.emit(). This broadcasts my custom
collided signal, which is declared with "signal collided" at the top of the
script. Whoever is listening(in tis case it ahve to be HitLabel's _on_player_collided() ) to that signal then runs their own function.

To set up that listener, I went to Main.gd, where _ready() runs once at startup,
when the engine is ready to do the binding:

	$Player.collided.connect($UserInterface/HitLabel._on_player_collided)

Here $Player is the Player node in Main.tscn, the node that Player.gd is attached
to and that emits the signal. The connection tells the signal that when it fires,
it should call _on_player_collided() on $UserInterface/HitLabel.


This turns the game into a practice mode: the Score shows how well you are
squashing creeps, and Hits shows how often you are getting caught.
