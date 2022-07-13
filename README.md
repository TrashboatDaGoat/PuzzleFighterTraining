# PuzzleFighterTraining
Package to help puzzle fighter players practice chains and other stuff with the Arcade ROM of puzzle fighter
place both the `run_spf2t_training.bat` and `puzzlefighter` folder in `/Fightcade/emulator/fbneo` folder (try to make sure there are no spaces in your filepath)

Run `run_spf2t_training.bat` to fire up training mode. It should work with either arcade or 2p about the same.

## Hotkeys
Lua hotkeys for special actions atm (bind them using FBNeo input options)

`Start`   : Open up the menu

`Hotkey 1`: Send queue'd Gems to player 1. Send queue'd gems to player 2 while holding up 

`Hotkey 2`: Get a free diamond

`Hotkey 3`: Change bottom gem of current piece. hold up to change top piece

`Hotkey 4`: Clear P1's board

'P1 Start button': bring up training menu (at least one second in game must pass for this to work)

## Training Menu
You can use the P1 start button to bring up the training menu. There you'll find plenty of useful options to help you practice. 
`Infinite Time`: only really affects Character select screen. Is mostly a teaching tool to help me learn how menu items work with lua

`P1/P2 Character`: Let's change the attack pattern of P1/P2. doesn't change the sprite until round change, but it will cause the voice to change

`Margin Time`: changes the lvl of Margin Time in effect. Margin time affects drop speed, Damage Multipliers, and if offset is active

`Margin Fix`: If this setting is turned on, margin time will stay at the lvl selected in `Margin Time`. Otherwise, the game clock will progress and increase Margin Time normally

`Show Display`: Determines whether or not the training modedisplay shows up or not

`No Diamond`: Let's you play as long as you want without a diamond showing up. `HotKey 2`'s insta diamond will bypass this feature

## Board Management Options
You can use the board management tab in the training menu to set how many queue'd gems for each player, and to force the next queue to have a certain piece (i.e force at least one red gem in every piece you get.) be careful, forcing the top piece will prevent you from getting diamonds.

`Send Gems to P1/P2`: changes the amount of gems that'll be sent to P1/P2 when you use `Hotkey 1` this number will also be visible on the training display

`Select Top/Bottom Piece`: Forces all your next pieces to have any non diamond piece in one of its slot. # WARNING: If you use force top piece you won't get a diamond, even `Hotkey 2` can't bypass this.

Set P2 garbage queue to 0 and send to reset damage so you can check how much you're doing on separate combos/attacks 


# Thanks and Recognition
* Huge thanks to Juicey and the Puzzle Fighter community for sparking the creation of the pazzule lab channel where we've learned so much about how the game works. It only takes 1 lol
* K.S. the hacker dog for uncovering so much about how garbage calculation works. their documentation and work for the X' patch made this a lot easier to do. Your work is the giant whose shoulders I stand on.
* Bankbank for opening my eyes up to the world of Romhacking. Showed me alot of stuff in the field that made the stuff i did in this project a lot easier
* I'd like to thank N-Bee for all their hard work helping this project function. Especially with all the gamedev project on their plate. I only asked them for a small consultation on possible this was and they really ran away with it.
*ChurritosConSalsa for help with the board clearing lua
*CaptainFlab for their assistance with code for changing the pieces on demand
* Last but not least the greater Puzzle Wednesday community for being supportive of this particular brand of mad puzzle science. 
