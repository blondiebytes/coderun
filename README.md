# coderun

An educational iOS game that teaches users how code works in real time. The user is a square and attempts to avoid obstacles while picking up code statements that dynamically change the game. 

Code statements at the current time include:

- Variable attributes such as o.color standing for the obstacle's color, p.color standing for the player's color, and bg.color standing for the background's color
- Values such as red, blue, green, and yellow. 

When the user has an attribute and picks up a value or has a value and picks up an attribute, the color of something on the screen (player, background, obstacle) changes to the value retrieved by the player (red, blue, green, etc)

Currently working on adding functionality to allow the player to change the patterns of these objects as well as a list of tasks (such as change the background to yellow) that allow the user to get double points if the task is completed.

The score is calculated from
- which and how many obstacles pass (300 for big, 200 for medium, 100 for small)
- when the user changes something onscreen by picking up code statements (500)
- (eventually, when the user completes a task) (1000)