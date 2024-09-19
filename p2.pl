/* 
Name(s): Ellie Alberty and Erik Claros
Email(s): eja028@email.latech.edu and ecl020@latech.edu
Date: 5/14/24
Course Number and Section: CSC330 001
Quarter: Spring 2024
Project # 2
*/

:- dynamic i_am_at/1, at/3, holding/1, num_ciggs/1, fileName/1.
:- retractall(at(_, _, _)), retractall(i_am_at(_)), retractall(alive(_)), retractall(holding(_)).

i_am_at(game_room).
num_ciggs(3).

/* This is the map for the game. I added paths between all of the rooms so that the player can travel*/
path(game_room, n, wall).
path(game_room, e, foyer).
path(game_room, s, bedroom).
path(game_room, w, wall). 
path(game_room, stairs, basement). 
path(basement, stairs, game_room).
path(foyer, n, wall).
path(foyer, e, courtyard).
path(courtyard, n, wall). 
path(courtyard, e, wall). 
path(courtyard, s, wall). 
path(courtyard, w, foyer).
path(foyer, s, kitchen). 
path(foyer, w, game_room). 
path(bedroom, n, game_room).
path(bedroom, e, kitchen).
path(bedroom, s, wall).
path(bedroom, w, wall).
path(bedroom, stairs, attic). 
path(attic, stairs, bedroom). 
path(kitchen, n, foyer).
path(kitchen, e, wall).
path(kitchen, s, wall).
path(kitchen, w, bedroom).
path(kitchen, passage, secret_room).
path(secret_room, passage, kitchen). 

/* Here is where all of our items are located. We have section off items based on location */

%  Game Room Items
at(chair, game_room, large).
at(golden_key, game_room, small).
at(ciggarette, game_room, small).
at(pool_table, game_room, large).

%  Attic Items
at(safe, attic, small).

%  Bedroom Items
at(bookshelf, bedroom, large).
at(rug, bedroom, large).
at(fireplace, bedroom, large).  

%  Kitchen Items
at(liquor_cabinet, kitchen, large). 
at(pantry, kitchen, large). 
at(vodka, kitchen, small).
at(roomba, kitchen, small). 

%  Foyer Items
at(statue, foyer, large).
at(desk, foyer, large). 
at(book, foyer, small).



/* Inventory predicate that displays the items in your inventory*/

inventory :- 
        holding(X),
        write(X), nl,
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'inventory.'), nl(File),
        write(File, 'You are holding the '), write(File, X), write(File, '.'), nl(File),
        close(File),
        fail.

inventory.
       
/* TThese rules are created for taking items. It also handels the case where you are attempting to 
pick up an item that doesnt exist or already have */


take(X) :-
        holding(X),
        write('You''re already holding it!'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place, small),
        retract(at(X, Place, small)),
        assert(holding(X)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'take('), write(File, X), write(File,').'), nl(File),
        write(File, 'You are now holding the '), write(File, X), write(File, '.'), nl(File),
        close(File),  
        write('OK.'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place, large),
        write('You try to lift it but it is too heavy.'),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'take('), write(File, X), write(File,').'), nl(File),
        write(File,'You try to lift it but it is too heavy.'), nl(File),
        close(File),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        retract(holding(_)),
        assert(holding(_)),     
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'take('), write(File,').'), nl(File),
        write(File, 'I don''t see it here.'), nl(File),
        close(File), nl.


/* These rules allow you to drop items in your inventory,it also writes the action on to the log file*/

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place,_)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'drop('), write(File, X), write(File, ').'), nl(File),
        write(File, 'You have dropped the '), write(File, X), write(File, '.'), nl(File),
        close(File),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        retract(holding(_)),
        assert(holding(_)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'drop('), write(File, ').'), nl(File),
        write(File, 'You aren''t holding it!'), nl(File),
        close(File),
        !,
        nl.


/* These rules define the direction you are taking. They n stands for north and so on */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

stairs :- go(stairs).

passage :- 
        go(passage),
        write('You walk down the spooky corridor more casually than you should be. Suddenly, the floor gives way beneath you and you fall into a ball pit. There is a spooky clown statue loves trivia. Your first question: Is a potato a vegatable or a fruit?'), nl,
        read(Answer),
        (Answer = vegatable -> write('Correct! You may continue on your journey.'), nl, go(passage); write('Wrong! You are now stuck in the ball pit forever.'), nl, die),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'passage.'), nl(File),
        write(File, 'You walk down the spooky corridor more casually than you should be. Suddenly, the floor gives way beneath you and you fall into a ball pit. There is a spooky clown statue loves trivia. Your first question: Is a potato a vegatable or a fruit?'), nl(File),
        write(File, Answer),
        (Answer = vegatable -> write(File, 'Correct! You may continue on your journey.'), nl(File); write(File, 'Wrong! You are now stuck in the ball pit forever.'), nl(File), write(File, 'die.'), nl(File)),
        close(File),
        !, nl.
        
/* This rule tells how to move in a given direction. */
go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, wall),
        write('You just ran into a wall.'),
        retract(i_am_at(Here)),
        assert(i_am_at(Here)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'go('), write(File, Direction), write(File, ').'), nl(File),
        write(File, 'You just ran into a wall.'), nl(File),
        close(File),
        !, nl.

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'go('), write(File, Direction), write(File, ').'), nl(File),
        close(File),
        look,
        !, nl.

go(_) :-
        write('You can''t go that way.'), nl.

/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place, Desc),
        write(Desc),
        nl,
        notice_objects_at(Place),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'look.'), nl(File),
        write(File, 'You are in the '), write(File, Place), write(File, '.'), nl(File),
        close(File),
        !, nl.

/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place, large),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* These rules allow the player to take a closer look at an object and get more information. */
observe(Object) :- 
        at(Object, Place, _),
        i_am_at(Place),
        describe(Object, Desc),
        write(Desc), nl,
        retract(at(Object, Place, _)),
        assert(at(Object, Place, small)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'observe('), write(File, Object), write(File, ').'), nl(File),
        write(File, Desc), nl(File),
        close(File),
        !, nl.

observe(_) :-
        write('I don''t see it here.'), nl.

% Takes the number of ciggarettes and decrements it by 1
% then saves the number until its called again
take_a_puff(0) :- write('You are all out of smokes. :'), nl.

take_a_puff(X):-
        X > 0,
        Y is X - 1,
        retract(num_ciggs(X)),
        assert(num_ciggs(Y)),
        write('You take a puff of your cigarette. You have '), write(Y), write(' left.'), nl.

use(ciggarette):-
        holding(ciggarette),
        num_ciggs(X), !,
        take_a_puff(X),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(ciggarette).'), nl(File),
        write(File, 'You take a puff of your cigarette. You have '), write(File, X), write(File, ' left.'), nl(File),
        close(File),
        !, nl.


% set of rules for different objects that perform different functions upon use of each object

use(golden_key) :- 
        holding(golden_key),
        i_am_at(bedroom),
        write('What is the password? Use an underscore to replace spaces'), nl,
        read(Answer),
        (Answer = 'megan_fox' -> write('You have made it! Thank you for playing the game. Credits: Erik and Eli creators'),die, nl; write('Wrong! Try again later.')),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(golden_key).'), nl(File),
        write(File, 'What is the password? Use an underscore to replace spaces'), nl(File),
        write(File, Answer), nl(File),
        (Answer = 'megan_fox' -> write(File, 'You have made it! Thank you for playing the game. Credits: Erik and Eli creators'), write(File, 'die.'), nl(File); write(File, 'Wrong! Try again later.'), nl(File)),
        close(File),
        !, nl.

use(book) :- 
        holding(book),
        write('You open the book and an envelope falls out named CSC 330 . Inside the envelope is written a single phrase with a missing part: Jason loves ___ ___?'),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(book).'), nl(File),
        write(File, 'You open the book and an envelope falls out named CSC 330 . Inside the envelope is written a single phrase with a missing part: Jason loves ___ ___?'), nl(File),
        close(File),
        !, nl.

use(vodka) :- 
        holding(vodka),
        write('You are now very drunk.'),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(vodka).'), nl(File),
        write(File, 'You are now very drunk.'), nl(File),
        close(File),
        !, nl.

use(roomba) :- 
        holding(roomba),
        i_am_at(bedroom),
        write('Vroom! Vroom! Vroom! The roomba cleans the rug. there is slowly revealed a bohemian pattern that obscurely spells out the sequence 2357'),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(roomba).'), nl(File),
        write(File, 'Vroom! Vroom! Vroom! The roomba cleans the rug. there is slowly revealed a bohemian pattern that obscurely spells out the sequence 2357'), nl(File),
        close(File),
        !, nl.

use(safe) :- 
        holding(safe),
        write('Input the four digit code: '), nl,
        read(Answer),
        (Answer = 2357 -> write('You opened the box! There''s a picture of Megan Fox? You know what to do and if you don''t then you will surely die!'), nl; write('That is incorrect. You won''t last long.'), nl),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(safe).'), nl(File),
        write(File, 'Input the four digit code: '), nl(File),
        write(File, Answer), nl(File),
        (Answer = 2357 -> write(File, 'You opened the box! There''s a picture of Megan Fox? You know what to do and if you don''t then you will surely die!'), nl(File); write(File, 'That is incorrect. You won''t last long.'), nl(File)),
        close(File),
        !, nl.

use(pool_table) :-
        i_am_at(game_room),
        write('Turns out you are really bad at pool. But there''s a golden key hidden underneath it. (take(golden_key))'),!,
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use(pool_table).'), nl(File),
        write(File, 'Turns out you are really bad at pool. But there''s a golden key hidden underneath it. (take(golden_key))'), nl(File),
        close(File),
        !, nl.

use(_) :- 
        write('You can''t use that object now or you don''t have it in your inventory.'), 
        retract(holding(_)),
        assert(holding(_)),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'use('), write(File, ').'), nl(File),
        write(File, 'You can''t use that object now or you don''t have it in your inventory.'), nl(File),
        close(File),
        !, nl.

use() :-
        write('Try putting an object inbetween the parenthesis.'), nl.

/* This rule tells how to die. */
die :-
        finish.

/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. You have died. Better luck next time... or not :)'),
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'The game is over. You have died. Better luck next time... or not :)'), nl(File),
        close(File),
        halt,
        nl.

/* This rule just writes out game instructions. */
/* Each instruction is followed up with a description as to what it does*/

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('n.  s.  e.  w. stairs.     -- to go in that direction.'), nl,
        write('take(Object).      -- to pick up an object.'), nl,
        write('drop(Object).      -- to put down an object.'), nl,
        write('observe(Object).   -- to look closer at an object.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('use(Object).       -- to use an object.'), nl,
        write('inventory.         -- to list the objects you are holding.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        write_instructions_to_file,
        nl.

write_instructions_to_file :-
        fileName(Stream),
        open(Stream, append, File),
        write(File, 'instructions.'), nl(File),
        write(File, 'Enter commands using standard Prolog syntax.'), nl(File),
        write(File, 'Available commands are:'), nl(File),
        write(File, 'start.             -- to start the game.'), nl(File),
        write(File, 'n.  s.  e.  w. stairs.     -- to go in that direction.'), nl(File),
        write(File, 'take(Object).      -- to pick up an object.'), nl(File),
        write(File, 'drop(Object).      -- to put down an object.'), nl(File),
        write(File, 'observe(Object).   -- to look closer at an object.'), nl(File),
        write(File, 'look.              -- to look around you again.'), nl(File),
        write(File, 'use(Object).       -- to use an object.'), nl(File),
        write(File, 'inventory.         -- to list the objects you are holding.'), nl(File),
        write(File, 'instructions.      -- to see this message again.'), nl(File),
        write(File, 'halt.              -- to end the game and quit.'), nl(File),
        close(File),
        !, nl.

/* This rule prints out instructions and tells where you are. */

start(X) :-
        open(X, write, _),
        assert(fileName(X)),
        instructions,
        look.

/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(game_room, 'You are in the game_room. There are doors to your east and south and a creaky stairwell going down into the earth.').
describe(foyer, 'You are in the foyer. There are doors to your west and south and east.').      
describe(bedroom, 'You are in bedroom. There are doors to your north and east and a creepy stairwell going up.').
describe(basement, 'You are in the basement. It seems to be flooded. Better get out of here.').
describe(courtyard, 'You are in the courtyard. It''s quite pretty out here but to bad there''s a fence and you are not athletic enough to scale it.').
describe(attic, 'You are in the attic. Kind of feel like there''s some ghosts up here. Amidst your terror you see a small safe in the corner (take(safe))').
describe(secret_room, 'You are in the secret room.').
describe(kitchen, 'You are in the kitchen. There are doors to your north and your east.').

describe(chair, 'the chair is made of wicker and no one is sitting in it. Someone left their ciggarettes on the seat though. (take(ciggarette))').
describe(desk, 'It is made of oak. You open the drawer and there is a book about prolog? Scary... (take(book))').
describe(rug, 'It looks very expensive. It also needs to be vacuumed.').
describe(fireplace, 'It is full of ashes.').
describe(bookshelf, 'You see lots of books such as the history of red herrings and the ballad of the goose chase but we don''t really care about those. A shiny gold book catches your eye. You remove it to reveal a safe with a keyhole.').
describe(liquor_cabinet, 'A variety of bottles line the shelves. A bottle of vodka with a cute little skull symbol catches your eye. (take(vodka))').
describe(pantry, 'The supply closet is filled with assorted cleaning supplies. There is a shiny red roomba (take(roomba)) and a mysterious crack in the wall. You stick your fingers in there because what else are you going to do and it slides open. This reveals a secret passage way. (Type passage if you don''t mind dying.)').
describe(safe, 'There is a keypad on the safe. (take(safe))').
describe(golden_key, 'it is make of solid gold and probably unlocks something').
describe(pool_table, 'Wanna play? Try using the pool_table').
describe(vodka, 'It looks quite tasty.').
describe(roomba, 'See anything dusty?').
describe(statue, 'It is a statue of Alain Colmerauer. I wonder who he is?').
describe(book, 'Maybe try giving me a read.').
