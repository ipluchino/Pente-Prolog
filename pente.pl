/* *********************************************************************
  Name:  Ian Pluchino                                                  *
  Project: OPL Project 4 Prolog                                        *
  Class: N/A                                                           *
  Date:  12/5/23                                                       *
********************************************************************* */

/* *********************************************************************
Clause Name: start_pente
Purpose: To start Pente - the entry point of the program.
Parameters: None
Return Value: None
Algorithm: None
Assistance Received: https://www.swi-prolog.org/changes/stack-limit.html
********************************************************************* */
start_pente :-
    %Increase the stack size to a really large number so no issues ever occur (just in case).
    set_prolog_flag(stack_limit, 32 000 000 000),
    %Ask the user if they would like to start a new tournament or load one from a file.
    get_tournament_decision(X),
    %Determine what to do based on their input.
    decide_tournament_start(X).

/* *********************************************************************
Clause Name: get_tournament_decision
Purpose: To get the user's decision on whether they would like to start a new tournament or load one from a file.
Parameters: Choice, an integer representing the user's choice. This is what is returned from the clause.
Return Value: Choice (see parameter list).
Algorithm: None.
Assistance Received: None
********************************************************************* */
get_tournament_decision(Choice) :-
    write('Options:'), nl,
    write('1. Start a new tournament.'), nl,
    write('2. Load a tournament from a file.'), nl, nl,
    write('Enter your choice (1 or 2): '),
    read(Input),
    validate_tournament_decision(Input, Choice).

/* *********************************************************************
Clause Name: validate_tournament_decision
Purpose: To validate the tournament decision.
Parameters: Input, an integer representing the user's choice.
            ValidatedInput, an integer representing input that has been validated. This is what is returned from the clause.
Return Value: ValidatedInput (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
validate_tournament_decision(Input, ValidatedInput) :-
    (Input == 1 ; Input == 2),
    ValidatedInput = Input.

validate_tournament_decision(_, ValidatedInput) :-
    write('Invalid tournament decision! Please re-enter: '),
    read(NewInput),
    validate_tournament_decision(NewInput, ValidatedInput).

/* *********************************************************************
Clause Name: decide_tournament_start
Purpose: To either start a new tournament or load one from a file based on the user's input.
Parameters: An integer (1 or 2), representing the way the user chose to start the tournament.
Return Value: None
Algorithm: None
Assistance Received: None
********************************************************************* */
decide_tournament_start(1) :-
    new_game_list(NewGameState),
    start_tournament(NewGameState).

decide_tournament_start(2) :-
    load_tournament(LoadedGameState), nl,
    start_tournament(LoadedGameState).

/* *********************************************************************
Clause Name: new_game_list
Purpose: To create a new game state list.
Parameters: A list of lists that will hold the new game state list. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
new_game_list([
    %Board
    [
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ],
      [ o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o ]
     ],
 
     %Human
     0, 0,
     
     %Computer
     0, 0,
 
     %Next player
     unknown, white]).

/* *********************************************************************
Clause Name: start_tournament
Purpose: To start the tournament loop and play rounds of Pente.
Parameters: GameState, a list representing the current state of the game.
Return Value: None
Algorithm:  1) Run a single round of Pente with the current game state.
            2) Once the round is complete, update the scores and reset the game state list in preparation for another round.  
            3) Ask the user if they would like to play another round.
            4) Recursively start another round, or display the winner of the tournament depending on the user's choice (see continue_tournament).
Assistance Received: None
********************************************************************* */
start_tournament(GameState) :-
    start_round(GameState, CompletedRoundGameState, play),
    
    %Display the finished round.
    write('COMPLETED ROUND:'), nl, nl,
    display_round_information(CompletedRoundGameState),

    %Update the scores.
    update_scores(CompletedRoundGameState, ScoresUpdatedGameState),

    %Reset the round
    reset_round(ScoresUpdatedGameState, ResetRoundGameState),

    %Ask the user if they would like to play again.
    get_continue_decision(Choice),

    %Play another round or end the tournament based on their choice.
    continue_tournament(Choice, ResetRoundGameState).

/* *********************************************************************
Clause Name: load_tournament
Purpose: To load a tournament from a file.
Parameters: LoadedGameState, a list representing the game state list loaded from a file. This is the return value of this clause.
Return Value: LoadedGameState (see parameter list).
Algorithm:  1) Ask the user for the file name to load the tournament from.
            2) Open the file and read its contents. The contents of the file will be a game state list.
            3) Close the file.
Assistance Received: https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
********************************************************************* */
load_tournament(LoadedGameState) :-
    %Get the name of the file the user wishes to load the tournament from.
    get_load_file_name(LoadFileName),

    %Open the file (already confirmed exists).
    open(LoadFileName, read, File),

    %Read the game state list from the file.
    read(File, LoadedGameState),

    %Close the file.
    close(File).

/* *********************************************************************
Clause Name: get_load_file_name
Purpose: To get the name of the file from the user that they would like to read in from.
Parameters: LoadFileName, a string representing the name of the file that the tournament will be loaded from. This is the return value of this clause.
Return Value: LoadFileName (see parameter list).
Algorithm:  1) Obtain the file name from the user.
            2) Add the .txt extension to the file name.
            3) Make sure the file exists.
            4) If the file does not exist, recursively ask the user for another file name until the file can be located. 
Assistance Received: None
********************************************************************* */
get_load_file_name(LoadFileName) :-
    write('Enter the file name to load from (without the .txt & first letter lowercase): '),
    read(Input),
    Extension = '.txt',
    atom_concat(Input, Extension, LoadFileName),
    %Make sure the file exists.
    exists_file(LoadFileName).

get_load_file_name(LoadFileName) :-
    write('File could not be found!'), nl,
    get_load_file_name(LoadFileName).

/* *********************************************************************
Clause Name: start_round
Purpose: To start and recursively play through a single round of Pente.
Parameters: GameState, a list representing the current state of the game.
            CompletedState, a list representing the game state list when the round is complete. This is what is returned from this clause.
            An atom (play or check_round_over), that determines if the round should be checked for completion, or if a turn should be played.
Return Value: CompletedState (see parameter list).
Algorithm:  1) Determine the first player of the round, if it hasn't yet been determined (see determine_first_player).
            2) If it is the Human's turn, let the Human play its turn. Otherwise let the Computer play it's turn.
            3) Recursively call start_round with the check_round_over parameter with the updated game state list (after a player has played through their turn).
            4) Check if the round is complete. If it is complete, this clause returns.
            5) While the round is not complete, recursively call this clause with the play parameter.
Assistance Received: None
********************************************************************* */
%If the first player hasn't been determined yet, determine it.
start_round(GameState, CompletedState, play) :-
	get_next_player(GameState, Player),
 	Player == unknown,
    determine_first_player(GameState, FirstPlayerState),
    start_round(FirstPlayerState, CompletedState, play).

%Human Turn.
start_round(GameState, CompletedState, play) :-
	get_next_player(GameState, Player),
 	Player == human,
    display_round_information(GameState),
    get_human_turn_decision(Choice),
    human_turn(GameState, Choice, UpdatedGameState),
    start_round(UpdatedGameState, CompletedState, check_round_over).
    
%Computer Turn.
start_round(GameState, CompletedState, play) :-
	get_next_player(GameState, Player),
 	Player == computer,
    display_round_information(GameState),
    get_computer_turn_decision(Choice),
    computer_turn(GameState, Choice, UpdatedGameState),
    start_round(UpdatedGameState, CompletedState, check_round_over).

%Determines if the round is over.
start_round(GameState, CompletedState, check_round_over) :-
    %Total the number of stones placed on the board - used to check if the board is full.
    all_board_locations(0, 0, BoardLocations),
    stones_placed_on_board(GameState, BoardLocations, TotalStonesPlacedOnBoard),

    %Search if either player has achieved five stones in a row.
    get_all_sequences(5, AllSequences),
    search_for_sequences(GameState, AllSequences, 5, 0, w, [], WhiteStonesWin),
    search_for_sequences(GameState, AllSequences, 5, 0, b, [], BlackStonesWin),

    %Decide what to do based on the above calculations.
    determine_round_over(GameState, CompletedState, TotalStonesPlacedOnBoard, WhiteStonesWin, BlackStonesWin).

/* *********************************************************************
Clause Name: get_next_player
Purpose: To get the next player from the game state list.
Parameters: GameState, a list representing the current state of the game.
            NextPlayer, an atom representing the next player of the current round. This is what is returned from this clause.
Return Value: NextPlayer (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_next_player(GameState, NextPlayer) :- nth0(5, GameState, NextPlayer).

/* *********************************************************************
Clause Name: determine_first_player
Purpose: To determine which player goes first at the very beginning of a round.
Parameters: GameState, a list representing the current state of the game.
            UpdatedGameState, a list representing the game state after the first player has been set. This is what is returned from this clause.
Return Value: UpdatedGameState (see parameter list).
Algorithm:  1) If the human has a higher tournament score, the human will play first.
            2) If the computer has a higher tournament score, the computer will play first.
            3) If the tournament scores are tied, the first player is determined via coin toss (see coin_toss).
Assistance Received: None
********************************************************************* */
%The human had the higher score.
determine_first_player(GameState, UpdatedGameState) :-
    get_human_score(GameState, HumanScore),
    get_computer_score(GameState, ComputerScore),
    HumanScore > ComputerScore,
    write('The human player goes first because they have a higher score.'), nl, nl,
    set_next_player(GameState, human, UpdatedGameState).

%The computer had a higher score.
determine_first_player(GameState, UpdatedGameState) :-
    get_human_score(GameState, HumanScore),
    get_computer_score(GameState, ComputerScore),
    ComputerScore > HumanScore,
    write('The computer player goes first because they have a higher score.'), nl, nl,
    set_next_player(GameState, computer, UpdatedGameState).
     
%The scores are tied.
determine_first_player(GameState, UpdatedGameState) :-
    write('The first player will be determined via coin toss, since the scores are tied or the tournament is just starting.'), nl,
    %Get the user's coin toss call.
    get_coin_toss_decision(Choice),
    
    %Flip the coin
    random(0,2, Coin),
    
    %Determine who goes first based on if the user won the coin toss or not.
    coin_toss(GameState, UpdatedGameState, Choice, Coin).

/* *********************************************************************
Clause Name: get_human_score
Purpose: To get the Human's score from the game state list.
Parameters: GameState, a list representing the current state of the game.
            HumanScore, an integer representing the human's tournament score. This is what is returned from this clause.
Return Value: HumanScore (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_human_score(GameState, HumanScore) :- nth0(2, GameState, HumanScore).

/* *********************************************************************
Clause Name: get_computer_score
Purpose: To get the Computer's score from the game state list.
Parameters: GameState, a list representing the current state of the game.
            ComputerScore, an integer representing the computer's tournament score. This is what is returned from this clause.
Return Value: ComputerScore (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_computer_score(GameState, ComputerScore) :- nth0(4, GameState, ComputerScore).

/* *********************************************************************
Clause Name: set_next_player
Purpose: To set the next player into a game state list.
Parameters: GameState, a list representing the old game state list.
            NewNextPlayer, the next player that is being set into the original game state list.
            A return list, that will hold the resulting newly updated game state list. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Validate the new next player.
set_next_player(GameState, NewNextPlayer, GameState) :-
    NewNextPlayer \= human,
    NewNextPlayer \= computer,
    NewNextPlayer \= unknown,
    write('Invalid next player!'), nl.

set_next_player([First, Second, Third, Fourth, Fifth, _ | RestOldState], NewNextPlayer, [First, Second, Third, Fourth, Fifth, NewNextPlayer | RestOldState]).

/* *********************************************************************
Clause Name: get_coin_toss_decision
Purpose: To get the coin toss call from the user.
Parameters: Choice, an integer representing the user's choice. This is what is returned from the clause.
Return Value: Choice (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_coin_toss_decision(Choice) :-
    write('Enter h for heads or t for tails: '),
    read(Input),
    validate_coin_toss_decision(Input, Choice).

/* *********************************************************************
Clause Name: validate_coin_toss_decision
Purpose: To validate the user's coin toss call.
Parameters: Input, an atom representing the user's choice.
            ValidatedInput, an atom representing input that has been validated. This is what is returned from the clause.
Return Value: ValidatedInput (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
validate_coin_toss_decision(Input, ValidatedInput) :-
    (Input == h; Input == t),
    ValidatedInput = Input.

validate_coin_toss_decision(_, ValidatedInput) :-
    write('Invalid coin toss decision! Re-enter h or t: '),
    read(NewInput),
    validate_coin_toss_decision(NewInput, ValidatedInput).

/* *********************************************************************
Clause Name: coin_toss
Purpose: To simulate a coin toss and set the next player based on who won the coin toss.
Parameters: GameState, a list representing the current state of the game.
            UpdatedGameState, a list representing the game state with the updated first player set. This is what is returned from the clause.
            An atom, h or t, representing the user's heads or tail coin toss call.
            An integer, 0 or 1, representing the simulated coin toss. 0 represents heads, and 1 represents tails.
Return Value: UpdatedGameState (see parameter list).
Algorithm:  1) If the human player called the coin toss correctly, they will play first.
            2) Otherwise, the computer player will play first.
Assistance Received: None
********************************************************************* */
%Heads - human correct.
coin_toss(GameState, UpdatedGameState, h, 0) :-
    write('The coin landed on Heads!'), nl,
    write('The Human player will go first because they won the coin toss.'), nl, nl,
	set_next_player(GameState, human, UpdatedGameState).

%Tails - human incorrect.
coin_toss(GameState, UpdatedGameState, h, 1) :-
    write('The coin landed on Tails!'), nl,
    write('The Computer player will go first because the human player lost the coin toss.'), nl, nl,
	set_next_player(GameState, computer, UpdatedGameState).

%Heads - human incorrect.
coin_toss(GameState, UpdatedGameState, t, 0) :-
    write('The coin landed on Heads!'), nl,
    write('The Computer player will go first because the human player lost the coin toss.'), nl, nl,
	set_next_player(GameState, computer, UpdatedGameState).

%Tails - human correct.
coin_toss(GameState, UpdatedGameState, t, 1) :-
    write('The coin landed on Tails!'), nl,
    write('The Human player will go first because they won the coin toss.'), nl, nl,
	set_next_player(GameState, human, UpdatedGameState).

/* *********************************************************************
Clause Name: display_round_information
Purpose: To display everything about the current round to the screen.
Parameters: GameState, a list representing the current state of the game.
Return Value: None
Algorithm:  1) Display the board.
            2) Display the human's information including their captured pair count and tournament score.
            3) Display the computer's information including their captured pair count and tournament score.
            4) Display the next player's information.
Assistance Received: None
********************************************************************* */
display_round_information(GameState) :-
    %Display the board.
    get_board(GameState, Board),
    row_headers(RowHeader),
    column_headers(ColHeader),
    display_board(Board, 0, RowHeader, ColHeader),

    %Display the Human's information.
    get_human_captured(GameState, HumanCaptured),
    get_human_score(GameState, HumanScore),
    write('Human:'), nl,
    write('Captured Pairs: '),
    write(HumanCaptured), nl,
    write('Tournament Score: '),
    write(HumanScore), nl,nl,

    %Display the Computer's information.
    get_computer_captured(GameState, ComputerCaptured),
    get_computer_score(GameState, ComputerScore),
    write('Computer:'), nl,
    write('Captured Pairs: '),
    write(ComputerCaptured), nl,
    write('Tournament Score: '),
    write(ComputerScore), nl,nl,

    %Display the next player's information.
    get_next_player(GameState, NextPlayer),
    get_next_player_color(GameState, NextPlayerColor),
    write('Next Player: '),
    write(NextPlayer),
    write(' - '),
    write(NextPlayerColor), nl, nl.

/* *********************************************************************
Clause Name: get_board
Purpose: To get the board from a game state list.
Parameters: GameState, a list representing the current state of the game.
            Board, a list representing the current board of the round. This is what is returned from this clause.
Return Value: Board (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_board(GameState, Board) :- nth0(0, GameState, Board).

/* *********************************************************************
Clause Name: row_headers
Purpose: To generate a list of row headers used for display purposes.
Parameters: A list, that will hold a list containing the row headers of the board. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
row_headers([19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]).

/* *********************************************************************
Clause Name: column_headers
Purpose: To generate a list of column headers used for display purposes.
Parameters: A list, that will hold a list containing the column headers of the board. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
column_headers(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S']).

/* *********************************************************************
Clause Name: display_board
Purpose: To print the entire board onto the screen.
Parameters: Board, a list representing the current board of the round.
            Index, an integer representing the current row that needs to be displayed.
            RowHeaders, a list representing the row headers for the board.
            ColumnHeaders, a list representing the column headers for the board.
Return Value: None
Algorithm:  1) Recursively loop through each row on the board.
            2) If the Index is 0, representing nothing has been printed yet, print the column headers since they should be on the top of the board.
            3) Attach the corresponding row header to the row list.
            4) Print each row of the board (see print_row) until all rows have been printed.
Assistance Received: None
********************************************************************* */
%Finished printing the board.
display_board(_, 19, _, _) :- nl.

%Printing the column headers first.
display_board(Board, 0, RowHeaders, ColumnHeaders) :- 
    %Column headers should be printed out first, if the index is 0.
    write('   '),
    print_row(ColumnHeaders),
    %Next, print the row.
    nth0(Index, Board, Row),
    nth0(Index, RowHeaders, RowHead),
    append([RowHead], Row, RowWithRowHeader),
    print_row(RowWithRowHeader),
    NewIndex is Index + 1,
    display_board(Board, NewIndex, RowHeaders, ColumnHeaders).

%Printing the board.
display_board(Board, Index, RowHeaders, ColumnHeaders) :- 
    nth0(Index, Board, Row),
    nth0(Index, RowHeaders, RowHead),
    append([RowHead], Row, RowWithRowHeader),
    print_row(RowWithRowHeader),
    NewIndex is Index + 1,
    display_board(Board, NewIndex, RowHeaders, ColumnHeaders).

/* *********************************************************************
Clause Name: print_row
Purpose: To print an individual row of the board on to the screen.
Parameters: A list, representing a row of the board.
Return Value: None
Algorithm:  1) Recursively loop through each column of the row.
            2) If the row header is less than 10, output an extra space for viewing purposes so that the board lines up correctly.
            3) Print each element of the row until all have been printed. Print stones as capital letters for viewing purposes.
Assistance Received: https://www.swi-prolog.org/pldoc/man?predicate=atom_string/2
                     https://www.swi-prolog.org/pldoc/man?predicate=string_upper/2
********************************************************************* */
%The row is empty.								  
print_row([]) :- nl.

%Special case when the row header is less than 10, print an extra space so everything lines up.
print_row([First | Rest]) :-
    number(First),
    First < 10,
    write(First),
    write('  '),
    print_row(Rest).

%Printing an entire row separated by spaces, convert empty locations to '-' for viewing purposes.
print_row([First | Rest]) :-
    First == o, 
    write('-'),
    write(' '),
    print_row(Rest).

%Printing an entire row separated by spaces.
%Note, if this clause gets executed its either a 'b' or a 'w'.
print_row([First | Rest]) :-
    %Convert the letter representing the stone into a capital letter for viewing purposes.
    atom_string(First, StoneString),
    string_upper(StoneString, Uppercase),
    write(Uppercase),
    write(' '),
    print_row(Rest).

/* *********************************************************************
Clause Name: get_human_captured
Purpose: To get the Human captured pair count from the game state list.
Parameters: GameState, a list representing the current state of the game.
            HumanCaptured, an integer representing the number of captured pairs the human player has. This is what is returned from this clause.
Return Value: HumanCaptured (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_human_captured(GameState, HumanCaptured) :- nth0(1, GameState, HumanCaptured).

/* *********************************************************************
Clause Name: get_computer_captured
Purpose: To get the Computer captured pair count from the game state list.
Parameters: GameState, a list representing the current state of the game.
            ComputerCaptured, an integer representing the number of captured pairs the computer player has. This is what is returned from this clause.
Return Value: ComputerCaptured (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_computer_captured(GameState, ComputerCaptured) :- nth0(3, GameState, ComputerCaptured).

/* *********************************************************************
Clause Name: get_next_player_color
Purpose: To get the next player's color from the game state list.
Parameters: GameState, a list representing the current state of the game.
            NextPlayerColor, an atom representing the color of the player going next in the round.
Return Value: NextPlayerColor (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_next_player_color(GameState, NextPlayerColor) :- nth0(6, GameState, NextPlayerColor).

/* *********************************************************************
Clause Name: get_human_turn_decision
Purpose: To get the Human player's turn decision.
Parameters: Choice, an integer representing the user's choice. This is what is returned from the clause.
Return Value: Choice (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_human_turn_decision(Choice) :-
    write('It is your turn. Please choose one of these options:'), nl,
    write('1. Place a stone.'), nl,
	write('2. Ask for help.'), nl, 
    write('3. Save and exit.'), nl, nl,
    write('Enter your choice (1-3): '),
    read(Input),
    validate_human_turn_decision(Input, Choice).

/* *********************************************************************
Clause Name: validate_human_turn_decision
Purpose: To validate the Human player's turn decision.
Parameters: Input, an integer representing the user's choice.
            ValidatedInput, an integer representing input that has been validated. This is what is returned from the clause.
Return Value: ValidatedInput (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */ 
validate_human_turn_decision(Input, ValidatedInput) :-
    (Input == 1 ; Input == 2; Input == 3),
    ValidatedInput = Input.

validate_human_turn_decision(_, ValidatedInput) :-
    write('Invalid human turn decision! Please re-enter: '),
    read(NewInput),
    validate_human_turn_decision(NewInput, ValidatedInput).

/* *********************************************************************
Clause Name: human_turn
Purpose: To play out the Human player's turn.
Parameters: GameState, a list representing the current state of the game.
            An integer (1, 2, or 3) representing what the human player would like to do on their turn.
            UpdatedGameState, a list representing the game state after the human player has taken their turn. This is what is returned from this clause.
Return Value: UpdatedGameState (see parameter list).
Algorithm: 1) If the user wants to place a stone:
                1a) Obtain the location the user wants to place their stone.
                1b) Update the board with the newly placed stone.
                1c) Clear any captured pairs and update the human's captured pair count if any occur.
                1d) Switch to the computer's turn and return the updated game state.
            2) If the user asks for help:
                2a) Obtain the optimal play through the optimal_play clause.
                2b) Display the optimal play to the screen.
            3) If the user wants to save and exit:
                3a) Save the game state into a file and terminate the program.
Assistance Received: None
********************************************************************* */
%The human wants to place a stone.
human_turn(GameState, 1, UpdatedGameState) :-
    get_human_color(GameState, HumanColor),
    get_board(GameState, CurrentBoard),
    
    %NEED TO FLUSH INPUT AFTER HUMAN TURN DECISION.
    %If the human want to place a stone, the input should be cleared.
    flush_input,
    read_location(GameState, Location), nl,
    nth0(0, Location, Column),
    nth0(1, Location, Row),

    %Convert the input to list indices.
    atom_number(Row, RowInteger),
    convert_row_index(RowInteger, ConvertedRow),
    convert_character_to_num(Column, ConvertedColumn),
    
    %Place the stone on the board.
    update_board(CurrentBoard, ConvertedRow, ConvertedColumn, HumanColor, UpdatedBoard),

    %Update the game state with the new board.
    set_board(GameState, UpdatedBoard, GameStateWithNewBoard),

    %Clear any captures off the board if any have occurred.
    generate_all_directions(Directions),
    generate_capture_sequences(ConvertedRow, ConvertedColumn, Directions, CaptureSequences),
    filter_sequences(CaptureSequences, FilteredCaptureSequences),
    clear_captures(GameStateWithNewBoard, FilteredCaptureSequences, human, HumanColor, ClearedCapturesState),

	%Switch turns
	switch_player(ClearedCapturesState, UpdatedGameState).     
    
%The human wants to ask for help.
human_turn(GameState, 2, GameState) :-
    %Get the optimal play.
    get_human_color(GameState, HumanColor),
	all_board_locations(0, 0, BoardLocations),
    stones_placed_on_board(GameState, BoardLocations, NumStones),
    optimal_play(GameState, HumanColor, NumStones, Location, Reasoning),
    nth0(0, Location, Row),
    nth0(1, Location, Column),

	%Explain the recommended move and why it is the most optimal play to the user.
    convert_row_index(Row, ConvertedRow),
    convert_num_to_character(Column, ConvertedColumn),
    write('HELP: The computer recommends you place your stone on '),
    write(ConvertedColumn),
    write(ConvertedRow),
    write(Reasoning), nl, nl.

%The human wants to save and exit.
human_turn(GameState, 3, GameState) :-
    save_tournament(GameState).

/* *********************************************************************
Clause Name: get_human_color
Purpose: To get the Human's stone color from the game state based on the next player information.
Parameters: GameState, a list representing the current state of the game.
            HumanColor, an atom representing the human player's stone color. This is what is returned from this clause.
Return Value: HumanColor (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Human is going next.
get_human_color(GameState, HumanColor) :-
    get_next_player(GameState, NextPlayer),
    NextPlayer == human,
    get_next_player_color(GameState, NextPlayerColor),
    NextPlayerColor == white,
    HumanColor = w.

%Human is going next.
get_human_color(GameState, HumanColor) :-
    get_next_player(GameState, NextPlayer),
    NextPlayer == human,
    HumanColor = b.

%Computer is going next.
get_human_color(GameState, HumanColor) :-
    get_next_player_color(GameState, NextPlayerColor),
    NextPlayerColor == white,
    HumanColor = b.

%Computer is going next.
get_human_color(_, HumanColor) :-
    HumanColor = w.

/* *********************************************************************
Clause Name: flush_input
Purpose: To flush the input buffer (clears newline characters).
Parameters: None
Return Value: None
Algorithm: None
Assistance Received: None
********************************************************************* */
flush_input :-
    read_line_to_string(user_input, _).

/* *********************************************************************
Clause Name: read_location
Purpose: To obtain a location to place a stone, from the user.
Parameters: GameState, a list representing the current state of the game.
            Result, a list representing the read in location input by the user. It will be in the format [Column, Row]. This is what is returned from this clause.
Return Value: Result (see parameter list).
Algorithm:  1) Ask the user to enter a location on the board.
            2) Return the validated and legal input.
Assistance Received: https://stackoverflow.com/questions/71470627/prolog-is-giving-random-numbers-instead-of-string-in-read-write-command
********************************************************************* */
read_location(GameState, Result) :-
    write('Enter a location, don\'t forget the period (ex: J10.): '),
    read_line_to_string(user_input, LocationString),
    
    %First, validate that the input is a legal move on the board.
    validate_location(GameState, LocationString, ValidatedLocation),
    
    %Next, make sure that the move legal, in the current context.
    all_board_locations(0, 0, BoardLocations),
    stones_placed_on_board(GameState, BoardLocations, TotalStones),
    
    legal_location(GameState, TotalStones, ValidatedLocation, Result).

/* *********************************************************************
Clause Name: validate_location
Purpose: To validate that the location entered by the user is sufficient. 
Parameters: GameState, a list representing the current state of the game.
            Input, a string representing the user's chosen location (Ex: J10).
            ValidatedLocation, a list in the format [Column, Row] representing the validated location on the board. This is what is returned from this clause.
Return Value: ValidatedLocation (see parameter list).
Algorithm:  1) First, ensure that the input is of the correct length (either 3 or 4 characters including the period).
            2) Parse the location passed into a list containing the column and row.
            3) Validate that the column is within board bounds.
            4) Validate that the row is numerical and within board bounds.
            5) Confirm the chosen location is empty on the board.
            6) Return the validated location.
Assistance Received: https://www.swi-prolog.org/pldoc/man?predicate=char_code/2
                     https://www.swi-prolog.org/pldoc/man?predicate=string_chars/2
                     https://www.swi-prolog.org/pldoc/man?predicate=atom_number/2
********************************************************************* */
%Make sure the input string is the correct length.
validate_location(GameState, Input, ValidatedLocation) :-
    %Note: InputLength should be four since there will be an additional period.
    string_length(Input, InputLength),
    InputLength \= 3,
    InputLength \= 4,
    write('Invalid length! Locations must be in the format \"J10.\"'), nl,
    read_location(GameState, ValidatedLocation).

%Make sure the column is valid.
validate_location(GameState, Input, ValidatedLocation) :-
    parse_location(Input, ParsedLocation),
    nth0(0, ParsedLocation, Column),
    convert_character_to_num(Column, NumericColumn),
    (NumericColumn < 0 ; NumericColumn > 18),
    write('Invalid Column! Columns must be from A-S.'), nl,
    read_location(GameState, ValidatedLocation).

%Make sure the row is valid.
validate_location(GameState, Input, ValidatedLocation) :-
    parse_location(Input, ParsedLocation),
    nth0(1, ParsedLocation, Row),
    atom_number(Row, RowInteger),
    (RowInteger < 1 ; RowInteger > 19),
    write('Invalid Row! Rows must be from 1-19.'), nl,
    read_location(GameState, ValidatedLocation).

%Confirm the location is empty
validate_location(GameState, Input, ValidatedLocation) :-
    parse_location(Input, ParsedLocation),
    nth0(0, ParsedLocation, Column),
    nth0(1, ParsedLocation, Row),

    %Confirm that the row is numerical.
    atom_number(Row, RowInteger),

    %Convert the input to list indices.
    convert_row_index(RowInteger, ConvertedRow),
    convert_character_to_num(Column, ConvertedColumn),

    %Check if the location entered is empty on the board.
    at(GameState, ConvertedRow, ConvertedColumn, AtLocation),
    AtLocation \= o,
    write('Invalid Location! The location provided is not empty.'), nl,
    read_location(GameState, ValidatedLocation).

%Everything is valid if the rule is true.
validate_location(_, Input, ValidatedLocation) :-
    parse_location(Input, ParsedLocation),
    nth0(1, ParsedLocation, Row),

    %Confirm that the row is numerical.
    atom_number(Row, _),

    %The location is valid in terms of the board constraints.
    ValidatedLocation = ParsedLocation.

%The row provided must not be numerical since atom_number failed.
validate_location(GameState, _, ValidatedLocation) :- 
    write('Invalid Row! Rows must numerical.'), nl,
    read_location(GameState, ValidatedLocation).

/* *********************************************************************
Clause Name: parse_location
Purpose: To parse a location string into its column and row.
Parameters: LocationString, a string representing the user's chosen location.
            A list, that will hold the resulting parsed location as a list in the format [Column, Row]. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: https://www.swi-prolog.org/pldoc/man?predicate=sub_string/5
                     https://stackoverflow.com/questions/6782007/prolog-how-to-convert-string-to-integer
********************************************************************* */
parse_location(LocationString, [Column, Row]) :-
    string_length(LocationString, LocationLength),
    LocationLengthMinusTwo is LocationLength - 2,
    sub_string(LocationString, 0, 1, _, Column),
    sub_string(LocationString, 1, LocationLengthMinusTwo, _, Row).

/* *********************************************************************
Clause Name: convert_character_to_num
Purpose: To convert a character (representing a column) into its numerical board representation.
Parameters: CharToConvert, a single character that is going to be converted to its integer representation.
            ConvertedCharacter, an integer representing the integer representation of the character. This is what is returned from this clause.
Return Value: ConvertedCharacter (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
convert_character_to_num(CharToConvert, ConvertedChar) :-
    string_chars(CharToConvert, [First | _]),
    char_code(First, CharASCII),
    ConvertedChar is CharASCII - 65.

/* *********************************************************************
Clause Name: convert_row_index
Purpose: To convert a board view row index to its respective list index or visa versa. 
Parameters: RowToConvert, an integer representing the board view row index to convert to its list index.
            ConvertedRow, an integer representing the converted list index from the board view row index. This is what is returned from this clause.
Return Value: ConvertedRow (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
convert_row_index(RowToConvert, ConvertedRow) :-
    ConvertedRow is 19 - RowToConvert.

/* *********************************************************************
Clause Name: at
Purpose: To determine what is on the board at a provided location.
Parameters: GameState, a list representing the current state of the game.
            Row, an integer representing the row of a location on the board.
            Column, an integer representing the column of a location on the board.
            Result, an atom representing what is on the board at the provided location. This is what is returned from this clause.
Return Value: Result (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
at(GameState, Row, Column, Result) :-
    get_board(GameState, Board),
    nth0(Row, Board, SelectedRow),
    nth0(Column, SelectedRow, Result).

/* *********************************************************************
Clause Name: all_board_locations
Purpose: To generate a list containing all possible board locations.
Parameters: Row, an integer representing the current row being evaluated.
            Col, an integer representing the current column being evaluated.
            ResultList, a list containing all of the valid board locations on the board. This is what is returned from this clause.
Return Value: ResultList (see parameter list).
Algorithm:  1) Recursively loop through each possible location on the board.
            2) If the row and column pair is valid, add it to the return list.
            2) If the column number gets greater than 18, move on to the next row.
            3) If the row number gets greater than 18, stop the recursion and return the list.
Assistance Received: None
********************************************************************* */
%Base case, all board locations have been listed.
all_board_locations(Row, _, []) :-
    Row > 18.

%If the column is greater than 18, go to the next row and reset the column.
all_board_locations(Row, Col, ResultList) :-
    Col > 18,
    NewRow is Row + 1,
    all_board_locations(NewRow, 0, ResultList).

%Add the current location to the list, and increment the column by 1.
all_board_locations(Row, Col, [CurrentLocation | RestLocations]) :-
    CurrentLocation = [Row, Col],
    NewCol is Col + 1,
    all_board_locations(Row, NewCol, RestLocations).

/* *********************************************************************
Clause Name: stones_placed_on_board
Purpose: To count and return the total number of stones placed on the board.
Parameters: GameState, a list representing the current state of the game.
            A list, containing all of the board locations on the board in the format [[Row, Col], [Row, Col], ...].
            TotalStones, an integer representing the total number of stones placed on the board. This is what is returned from this clause.
Return Value: TotalStones (see parameter list).
Algorithm:  1) Recursively loop through each of the board locations on the board.
            2) If the location on the board is not empty, increment the return value by 1 and recursively call this clause.
            3) Once all board locations have been checked, return the total number of stones found on the board.
Assistance Received: None
********************************************************************* */
%Base case.
stones_placed_on_board(_, [], 0).

%There is a stone at the location.
stones_placed_on_board(GameState, [[Row, Col] | Rest], TotalStones) :-
    at(GameState, Row, Col, AtLocation),
    AtLocation \= o,
    stones_placed_on_board(GameState, Rest, NewTotalStones),
    TotalStones is NewTotalStones + 1.

%There is not a stone at the location.
stones_placed_on_board(GameState , [_ | Rest], TotalStones) :-
    stones_placed_on_board(GameState, Rest, TotalStones).

/* *********************************************************************
Clause Name: legal_location
Purpose: To ensure that a chosen location by the user is legal in the current game context.
Parameters: GameState, a list representing the current state of the game.
            An integer representing the total number of stones placed on the board.
            ParsedLocation, a list containing the row and column of a location on the board.
            LegalizedLocation, a list containing a confirmed legal location on the board. This is what is returned from this clause.
Return Value: LegalizedLocation (see parameter list).
Algorithm:  1) If there isn't any stones placed on the board yet, make sure the first stone is being played on J10.
            2) If there are only two stones placed on the board, make sure the location is within handicap bounds.
            3) Otherwise, return the legal location.
Assistance Received: None
********************************************************************* */
%Making sure the first stone of the game is placed on J10.
legal_location(GameState, 0, ParsedLocation, LegalizedLocation) :-
    nth0(0, ParsedLocation, Column),
    nth0(1, ParsedLocation, Row),
    atom_number(Row, RowInt),
    Column \= 'J',
    RowInt \= 10,
    write('Illegal location! The first stone of the game must be placed on J10.'), nl,
    read_location(GameState, LegalizedLocation).

%Making sure the second stone of the first player is at least three intersections away from the center (J10).    
legal_location(GameState, 2, ParsedLocation, LegalizedLocation) :-
    nth0(0, ParsedLocation, Column),
    nth0(1, ParsedLocation, Row),
    atom_number(Row, RowInt),
    convert_character_to_num(Column, ColumnInt),
    %Note: The location is illegal if G < col < M AND 7 < row < 13.
    ColumnInt > 6,
    ColumnInt < 12,
    RowInt > 7,
    RowInt < 13,
    write('Illegal location! The second stone of the first player must be at least three intersections away from the center (J10).'), nl,
    read_location(GameState, LegalizedLocation).

%The move is legal.
legal_location(_, _, ParsedLocation, LegalizedLocation) :-
    LegalizedLocation = ParsedLocation.

/* *********************************************************************
Clause Name: update_board
Purpose: To update a location on the board with a provided symbol.
Parameters: A list, containing the original board in the format [Row0, Row1, ... RestRows].
            RowIndex, an integer representing the index of row that needs to be updated.
            ColumnIndex, an integer representing the index of the column that needs to be updated.
            Symbol, an atom representing the symbol to update the location on the board to.
            A return list, containing the updated board with the newly stone placed. This is what is returned by this clause.
Return Value: (see parameter list).
Algorithm:  1) If the rowIndex is 0, that means that we are at the correct row to be updated. 
                1a) Update the column (see update_column)
                1b) Return a list from this row to the end of the rows.  
            2) Otherwise, add the current row to the result board list, and recursively call this clause with one subtracted from the row index.
Assistance Received: None
********************************************************************* */
%Base case.
update_board([FirstRow | RestRows], 0, ColumnIndex, Symbol, [UpdatedRow | RestRows]) :-
    update_column(FirstRow, ColumnIndex, Symbol, UpdatedRow).

%Recursive case - search for the correct row to update.
update_board([FirstRow | RestRows], RowIndex, ColumnIndex, Symbol, [FirstRow | UpdatedRestRows]) :-
    NewRowIndex is RowIndex - 1,
    update_board(RestRows, NewRowIndex, ColumnIndex, Symbol, UpdatedRestRows).

/* *********************************************************************
Clause Name: update_column
Purpose: To update the column of a provided row on the board with a provided symbol.
Parameters: A list, representing one full row on the board.
            ColumnIndex, an integer representing the index of the column that needs to be updated.
            Symbol, an atom representing the symbol to update the column to.
            A return list, containing the updated row with the newly stone placed. This is what is returned by this clause.
Return Value: (see parameter list).
Algorithm:  1) If the columnIndex is 0, that means that we are at the correct column to be updated. 
                1a) Insert the symbol.
                2a) Return a list from this index to the end of the row.
            2) Otherwise, add the current column to the result row list, and recursively call this clause with one subtracted from the column index.
Assistance Received: None
********************************************************************* */
%Base case.
update_column([_ | Rest], 0, Symbol, [Symbol | Rest]).

%Recursive case - search for the correct column in the row to update.
update_column([FirstColumn | RestColumns], ColumnIndex, Symbol, [FirstColumn | UpdatedRestColumns]) :-
    NewColumnIndex is ColumnIndex - 1,
    update_column(RestColumns, NewColumnIndex, Symbol, UpdatedRestColumns).

/* *********************************************************************
Clause Name: set_board
Purpose: To set the board into a game state list.
Parameters: GameState, a list representing the current game state list.
            NewBoardoard, a list representing a board that will replace the old board in the game state list.
            A return list, representing the game state containing the new board. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
set_board([ _ | RestOldState], NewBoard, [NewBoard | RestOldState]) :-
    %Validate the board is 19x19.
    length(NewBoard, NumRows),
    nth0(0, NewBoard, FirstRow),
    length(FirstRow, NumColumns),
    NumRows == 19,
    NumColumns == 19.

set_board(GameState, _, GameState) :-
    write('Invalid board!'), nl.

/* *********************************************************************
Clause Name: generate_all_directions
Purpose: To generate a list of all eight possible directions on the board in the form of (rowChange, colChange).
Parameters: A return list, representing all eight possible directions on the board. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
generate_all_directions([[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]).

/* *********************************************************************
Clause Name: generate_capture_sequences
Purpose: To generate all capture sequences that need to be checked, based on a provided location.
Parameters: Row, an integer representing a row of the board.
            Col, an integer representing a col of the board.
            A list, representing all eight possible directions on the board (see generate_all_directions).
            A return list, containing all the sequences of locations that needs to be checked for capture. This is what is returned by this clause.
Return Value: (see parameter list).
Algorithm:  1) Recursively loop through each direction that needs to be searched.
            2) For each direction, generate a sequence containing three locations away in the current direction.
            3) Add the sequence to the return list and continue searching the rest of the directions.
Assistance Received: None
********************************************************************* */
%Base case.
generate_capture_sequences(_, _, [], []).

%Recursive case - loop through each direction and add it onto the sequence.
generate_capture_sequences(Row, Col, [[RowChange, ColChange] | RestDirections], [CaptureSequence | RestCaptureSequences]) :-
    %Only need to consider the three locations away from the current location being evaluated. Ex: * W W B where * is being evaluated. 
    get_sequence(Row, Col, RowChange, ColChange, 4, [_ | CaptureSequence]),
    generate_capture_sequences(Row, Col, RestDirections, RestCaptureSequences).

/* *********************************************************************
Clause Name: get_sequence
Purpose: To generate a single sequence of locations a provided distance and direction, starting from a specified row and column. 
Parameters: CurrentRow, an integer representing the row of a location on the board.
            CurrentCol, an integer representing the column of a location on the board.
            RowChange, an integer representing the directional change applied to each row.
            ColChange, an integer representing the directional change applied to each column.
            Distance, an integer representing the length of sequences to generate.
            A return list, containing all of the locations in the generated sequence. This is what is returned by this clause.
Return Value: (see parameter list).
Algorithm:  1) Recursively generate locations in a provided direction.
            2) Continue generating locations recursively until the return list is of 'distance' length.
Assistance Received: None
********************************************************************* */
%Base case.
get_sequence(_, _, _, _, 0, []).

%Recursively generate a sequence of locations.
get_sequence(CurrentRow, CurrentCol, RowChange, ColChange, Distance, [CurrentLocation | Rest]) :-
    %Store the current location.
    CurrentLocation = [CurrentRow, CurrentCol],

    %Decrement the distance by 1 and generate the next location in the sequence.
    NewDistance is Distance - 1,
    NewRow is CurrentRow + RowChange,
    NewCol is CurrentCol + ColChange,

    %Continue generating locations until the list of sequences is the correct size.
    get_sequence(NewRow, NewCol, RowChange, ColChange, NewDistance, Rest).

/* *********************************************************************
Clause Name: filter_sequences
Purpose: To filter out invalid sequences of locations from a list containing valid and invalid sequences of locations.
Parameters: A list, representing a sequence of locations.
            A return list, representing only valid sequences of locations. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm:  1) Recursively loop through each sequence of locations provided to this clause.
            2) If the sequence contains only valid locations, add it to the return list. Otherwise do not add it it.
            3) Continue searching the rest of the sequences of locations. 
Assistance Received: None
********************************************************************* */
%Base case.
filter_sequences([], []).

%The current sequence is valid.
filter_sequences([CurrentSequence | RestSequences], [CurrentSequence | RestFiltered]) :-
    valid_sequence(CurrentSequence),
    filter_sequences(RestSequences, RestFiltered).

%The current sequence is invalid.
filter_sequences([_ | RestSequences], FilteredSequences) :-
    filter_sequences(RestSequences, FilteredSequences).

/* *********************************************************************
Clause Name: valid_sequence
Purpose: To validate that a provided sequence of locations contains all valid board locations.
Parameters: A list, representing a sequence of locations.
Return Value: None
Algorithm:  1) Recursively loop through each location within the sequence.
            2) If any of the locations are not valid within constraints of the board, this clause will fail.
Assistance Received: None
********************************************************************* */
%Base case - all locations were valid.
valid_sequence([]) :- true.

%Recursive case - the current location is valid.
valid_sequence([CurrentLocation | Rest]) :-
    nth0(0, CurrentLocation, Row),
    nth0(1, CurrentLocation, Col),
    valid_indices(Row, Col),
    valid_sequence(Rest).

/* *********************************************************************
Clause Name: valid_indices
Purpose: To validate that a provided row and column pair are valid.
Parameters: Row, an integer representing a row of the board.
            Col, an integer representing a col of the board.
Return Value: None
Algorithm: None
Assistance Received: None
********************************************************************* */
%Validates that a row/column pair is valid. Fails otherwise.
valid_indices(Row, Col) :-
    Row =< 18,
    Row >= 0,
    Col =< 18,
    Col >= 0,
    true.

/* *********************************************************************
Clause Name: clear_captures
Purpose: To clear captured pairs off the board and update the player's captured pair count accordingly.
Parameters: GameState, a list representing the current state of the game.
            A list reprsenting all of the possible capture sequences that need to be checked after a player has placed a stone.
            An atom (either human or computer), representing which player's turn it is.
            Color, a character representing the current player's stone color.
            UpdatedGameState, a list representing the updated game state with the captured pairs removed and captured pair counts updated. This is what is returned by this clause.
Return Value: UpdatedGameState (see parameter list).
Algorithm:  1) Recursively loop through each capture sequence provided to this clause in the first parameter.
            2) For each capture sequence, extract and store the three locations within the capture sequence that needs to be evaluated.
            3) If the three locations contain stones in the pattern: O O P where O represents the opponent's stones and P represents the player's stone:
                3a) Remove the first and second stones in the sequence, and store this game state.
                3b) If the player parameter is human, increment the Human's captured pair count by 1. Otherwise, increment the Computer's captured pair count.
                3c) Recursively call this clause with the updated game state to check the rest of the capture sequences (multiple captures can happen at one time).
            4) Otherwise, continue checking the rest of the sequences through recursively calling this clause.
Assistance Received: None
********************************************************************* */
%Base case, when all the capture sequences have been checked.
clear_captures(GameState, [], _, _, GameState).

%Recursive case - where a capture occurred for the human.
clear_captures(GameState, [[[Row1, Col1], [Row2, Col2], [Row3, Col3]] | RestSequences], human, Color, UpdatedGameState) :-
    get_board(GameState, Board),
	opponent_color(Color, OpponentColor),
	
    %Extract what is at each location.
    at(GameState, Row1, Col1, AtLocation1),
    at(GameState, Row2, Col2, AtLocation2),
    at(GameState, Row3, Col3, AtLocation3),
    
    %If the stones are in the pattern * O O P, where O is the opponent's stone and P is the player's stone, a capture can be made.
    AtLocation1 = OpponentColor,
    AtLocation2 = OpponentColor,
    AtLocation3 = Color,

    %Update the human's captured pair count.
    get_human_captured(GameState, HumanCaptured),
    NewHumanCaptured is HumanCaptured + 1,
    set_human_captured(GameState, NewHumanCaptured, ScoreUpdatedState),

    %Remove the captured pair off the board (1st and 2nd stone in the capture sequence).
    update_board(Board, Row1, Col1, o, RemovedFirstStoneBoard),
	update_board(RemovedFirstStoneBoard, Row2, Col2, o, RemovedSecondStoneBoard),
	set_board(ScoreUpdatedState, RemovedSecondStoneBoard, ClearedCapturesState),

    %Check the rest of the capture sequences (more than 1 capture can occur at a time.
    clear_captures(ClearedCapturesState, RestSequences, human, Color, UpdatedGameState).
    
%Recursive case - where no capture occurred continue searching the capture sequences. For the human.
clear_captures(GameState, [_ | RestSequences], human, Color, UpdatedGameState) :-
    clear_captures(GameState, RestSequences, human, Color, UpdatedGameState).

%Recursive case - where a capture occurred for the computer.
clear_captures(GameState, [[[Row1, Col1], [Row2, Col2], [Row3, Col3]] | RestSequences], computer, Color, UpdatedGameState) :-
    get_board(GameState, Board),
	opponent_color(Color, OpponentColor),
	
    %Extract what is at each location.
    at(GameState, Row1, Col1, AtLocation1),
    at(GameState, Row2, Col2, AtLocation2),
    at(GameState, Row3, Col3, AtLocation3),
    
    %If the stones are in the pattern * O O P, where O is the opponent's stone and P is the player's stone, a capture can be made.
    AtLocation1 = OpponentColor,
    AtLocation2 = OpponentColor,
    AtLocation3 = Color,

    %Update the computer's captured pair count.
    get_computer_captured(GameState, ComputerCaptured),
    NewComputerCaptured is ComputerCaptured + 1,
    set_computer_captured(GameState, NewComputerCaptured, ScoreUpdatedState),

    %Remove the captured pair off the board (1st and 2nd stone in the capture sequence).
    update_board(Board, Row1, Col1, o, RemovedFirstStoneBoard),
	update_board(RemovedFirstStoneBoard, Row2, Col2, o, RemovedSecondStoneBoard),
	set_board(ScoreUpdatedState, RemovedSecondStoneBoard, ClearedCapturesState),

    %Check the rest of the capture sequences (more than 1 capture can occur at a time.
    clear_captures(ClearedCapturesState, RestSequences, computer, Color, UpdatedGameState).
    
%Recursive case - where no capture occurred continue searching the capture sequences. For the computer.
clear_captures(GameState, [_ | RestSequences], computer, Color, UpdatedGameState) :-
    clear_captures(GameState, RestSequences, computer, Color, UpdatedGameState).

/* *********************************************************************
Clause Name: opponent_color
Purpose: To get the stone color of the opponent.
Parameters: An atom (either w or b) representing the current player's stone color.
            An atom (either w or b) representing the opponent's stone color. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
opponent_color(w, b).
opponent_color(b, w).

/* *********************************************************************
Clause Name: set_human_captured
Purpose: To set the Human's captured pair count into the game list.
Parameters: GameState, a list representing the current game state list.
            NewHumanCaptured, an integer representing the captured pair count to set the human's captured pairs to.
            A return list, representing the updated game state list with the newly human captured pair count set. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Validate the new human captured pair counts.
set_human_captured([First, _ | RestOldState], NewHumanCaptured, [First, NewHumanCaptured | RestOldState]) :-
    NewHumanCaptured >= 0.

set_human_captured(GameState, _, GameState) :-
    write('Invalid human captured pair count!'), nl.

/* *********************************************************************
Clause Name: set_computer_captured
Purpose: To set the Computer's captured pair count into the game list. 
Parameters: GameState, a list representing the current game state list.
            NewComputerCaptured, an integer representing the captured pair count to set the computer's captured pairs to.
            A return list, representing the updated game state list with the newly computer captured pair count set. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
set_computer_captured([First, Second, Third, _ | RestOldState], NewComputerCaptured, [First, Second, Third, NewComputerCaptured | RestOldState]) :-
    NewComputerCaptured >= 0.

set_computer_captured(GameState, _, GameState) :-
    write('Invalid computer captured pair count!'), nl.

/* *********************************************************************
Clause Name: switch_player
Purpose: To switch to the next player of the round.
Parameters: GameState, a list representing the current game state list.
            UpdatedGameState, a list representing the game state with the next player set. This is what is returned from this clause.
Return Value: UpdatedGameState (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
switch_player(GameState, UpdatedGameState) :-
    get_next_player(GameState, Player),
    Player == human,
    switch_color(GameState, ColorSwitched),
    set_next_player(ColorSwitched, computer, UpdatedGameState).

switch_player(GameState, UpdatedGameState) :-
    switch_color(GameState, ColorSwitched),
    set_next_player(ColorSwitched, human, UpdatedGameState).

/* *********************************************************************
Clause Name: switch_color
Purpose: To switch the next player color of the round.
Parameters: GameState, a list representing the current game state list.
            UpdatedGameState, a list representing the game state with the next player color set. This is what is returned from this clause.
Return Value: UpdatedGameState (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
switch_color(GameState, UpdatedGameState) :-
    get_next_player_color(GameState, Color),
    Color == white,
    set_next_player_color(GameState, black, UpdatedGameState).

switch_color(GameState, UpdatedGameState) :-
    set_next_player_color(GameState, white, UpdatedGameState).

/* *********************************************************************
Clause Name: set_next_player_color
Purpose: To set the next player's color into a game state list.
Parameters: GameState, a list representing the current game state list.
            NewNextPlayerColor, an atom representing the stone color to set the next player color to in game state list.
            A return list, representing the updated game state list with the new next player color set.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Validate the new next player color.
set_next_player_color(GameState, NewNextPlayerColor, GameState) :-
    NewNextPlayerColor \= white,
    NewNextPlayerColor \= black,
    write('Invalid next player color!'), nl.

set_next_player_color([First, Second, Third, Fourth, Fifth, Sixth | _], NewNextPlayerColor, [First, Second, Third, Fourth, Fifth, Sixth, NewNextPlayerColor]).

/* *********************************************************************
Clause Name: save_tournament
Purpose: To save the tournament to a file.
Parameters: GameState, a list representing the current game state list.
Return Value: None
Algorithm:  1) Obtain the file name the user wishes to save to. The file is made sure it exists.
            2) Obtain the game state list from within the save file.
            3) Close the file.
            4) Terminate the program.
Assistance Received: https://stackoverflow.com/questions/22747147/swi-prolog-write-to-file
                     https://www.swi-prolog.org/pldoc/man?predicate=catch/3
                     https://www.swi-prolog.org/pldoc/man?predicate=halt/0
********************************************************************* */
save_tournament(GameState) :-
    %Get the name of the file the user wishes to save the tournament to.
    get_save_file_name(GameState, SaveFileName),
    
    %Handling invalid file name errors (when creating the file).
    catch(open(SaveFileName, write, File), error(_, _), invalid_save_file_name(GameState)),

    %Output the gamestate list to the file, and then close the file.
    write(File, GameState),
    write(File, '.'),
    close(File),

    %Exit the program.
    halt.

/* *********************************************************************
Clause Name: get_save_file_name
Purpose: To get the name of the file the user wishes to save the tournament to.
Parameters: GameState, a list representing the current state of the game.
            SaveFileName, an atom representing the name of the file the tournament will be saved to. This is what is returned from this clause.
Return Value: SaveFileName (see parameter list).
Algorithm: None
Assistance Received: https://www.swi-prolog.org/pldoc/man?predicate=catch/3
********************************************************************* */
get_save_file_name(GameState, SaveFileName) :-
    write('Enter the file name to save to (without the .txt & first letter lowercase): '),
    %Handling input errors.
    catch(read(Input), error(_, _), invalid_save_file_name(GameState)),
    Extension = '.txt',
    %Handling concatenation errors when adding the extension name to the file.
    catch(atom_concat(Input, Extension, SaveFileName), error(_, _), invalid_save_file_name(GameState)).

/* *********************************************************************
Clause Name: invalid_save_file_name
Purpose: To catch any errors that occur when an invalid save file name is input by the user.
Parameters: GameState, a list representing the current state of the game.
Return Value: None
Algorithm: None
Assistance Received: None
********************************************************************* */
%Gets called if the save file name is invalid.
invalid_save_file_name(GameState) :-
    write('Invalid save file name!'), nl,
    save_tournament(GameState).

/* *********************************************************************
Clause Name: get_computer_turn_decision
Purpose: To get the Computer player's turn decision.
Parameters: Choice, an integer representing the user's choice. This is what is returned from the clause.
Return Value: Choice (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_computer_turn_decision(Choice) :-
	write('It is the computer\'s turn. Please choose one of these options:'), nl,
    write('1. Let the computer place a stone.'), nl,
    write('2. Save and exit.'), nl, nl,
    write('Enter your choice (1 or 2): '),
    read(Input),
    validate_computer_turn_decision(Input, Choice).

/* *********************************************************************
Clause Name: validate_computer_turn_decision
Purpose: To validate the Computer player's turn decision.
Parameters: Input, an integer representing the user's choice.
            ValidatedInput, an integer representing input that has been validated. This is what is returned from the clause.
Return Value: ValidatedInput (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
validate_computer_turn_decision(Input, ValidatedInput) :-
    (Input == 1; Input == 2),
    ValidatedInput = Input.

validate_computer_turn_decision(_, ValidatedInput) :-
    write('Invalid computer turn decision! Please re-enter: '),
    read(NewInput),
    validate_computer_turn_decision(NewInput, ValidatedInput).

/* *********************************************************************
Clause Name: computer_turn
Purpose: To play out the Computer player's turn.
Parameters: GameState, a list representing the current state of the game.
            An integer (1 or 2) representing what the userr would like to do on the computer's turn.
            UpdatedGameState, a list representing the game state after the computer player has taken their turn. This is what is returned from this clause.
Return Value: UpdatedGameState (see parameter list).
Algorithm:  1) If the user wants the comptuer to place its stone:
                1a) Obtain the optimal play through the optimal_play clause.
                1b) Update the board with the newly placed stone at this location and display what the computer did to the user.
                1c) Clear any captured pairs and update the computer's captured pair count if any occur.
            2) If the user wants to save and exit:
                2a) Save the game state into a file and terminate the program.
Assistance Received: None
********************************************************************* */
%The user wants the computer to place a stone.
computer_turn(GameState, 1, UpdatedGameState) :-
    get_computer_color(GameState, ComputerColor),
    get_board(GameState, CurrentBoard),

	%Get the optimal play.
	all_board_locations(0, 0, BoardLocations),
    stones_placed_on_board(GameState, BoardLocations, NumStones),
    optimal_play(GameState, ComputerColor, NumStones, Location, Reasoning),
    nth0(0, Location, Row),
    nth0(1, Location, Column),

	%Explain the reasoning for the computer's move to the user.
    convert_row_index(Row, ConvertedRow),
    convert_num_to_character(Column, ConvertedColumn),
    write('The computer placed its stone on '),
    write(ConvertedColumn),
    write(ConvertedRow),
    write(Reasoning), nl, nl,

	%Place the stone on the board.
	update_board(CurrentBoard, Row, Column, ComputerColor, UpdatedBoard),

	%Update the game state with the new board.
    set_board(GameState, UpdatedBoard, GameStateWithNewBoard),

	%Clear any captures off the board if any have occurred.
    generate_all_directions(Directions),
    generate_capture_sequences(Row, Column, Directions, CaptureSequences),
    filter_sequences(CaptureSequences, FilteredCaptureSequences),
    clear_captures(GameStateWithNewBoard, FilteredCaptureSequences, computer, ComputerColor, ClearedCapturesState),

	%Switch turns
	switch_player(ClearedCapturesState, UpdatedGameState). 

%The user wants to save and exit.
computer_turn(GameState, 2, GameState) :-
    save_tournament(GameState).

/* *********************************************************************
Clause Name: get_computer_color
Purpose: To get the Computer's stone color from the gamestate based on the next player information.
Parameters: GameState, a list representing the current state of the game.
            ComputerColor, an atom representing the computer player's stone color. This is what is returned from this clause.
Return Value: ComputerColor (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_computer_color(GameState, ComputerColor) :-
    get_next_player(GameState, NextPlayer),
    NextPlayer == computer,
    get_next_player_color(GameState, NextPlayerColor),
    NextPlayerColor == white,
    ComputerColor = w.

get_computer_color(GameState, ComputerColor) :-
    get_next_player(GameState, NextPlayer),
    NextPlayer == computer,
    ComputerColor = b.

get_computer_color(GameState, ComputerColor) :-
    get_next_player_color(GameState, NextPlayerColor),
    NextPlayerColor == white,
    ComputerColor = b.

get_computer_color(_, ComputerColor) :-
    ComputerColor = w.

/* *********************************************************************
Clause Name: optimal_play
Purpose: To determine the most optimal location to place a stone.
Parameters: GameState, a list representing the current state of the game.
            Color, an atom representing the player's stone color.
            An integer, representing the number of stones placed on the board.
            Location, a list representing the optimal play location in the format [Row, Col]. This is what is returned from this clause.
            Reasoning, an explanation on why the computer chose the optimal play location. This is also what is returned from this clause.
Return Value: Location and Reasoning (see parameter list).
Algorithm:  Several clauses are used to determine the most optimal play. See individual clause documentation for more information. 
            The priorities are listed below and determined via the determine_optimal_play clause:
            1) If there are no stones placed on the board (the board is empty), the only possible move is the center of the board, or J10.
            2) If it is the second turn of the player that went first, the optimal play generated must be at least three intersections away from the center (J10).
            The location returned will be at least three intersections away from the center (ex: w o o * o).
            3) If it is possible to win the round with the player's next move, either by five consecutive stones or by capture, the location that results in a win is returned.
                3a) If it's possible to delay the win to earn additional points, the win will be delayed (see make_winning_move for details on delaying the win).
            4) If the opponent is about to win the round, either by five consecutive stones or by capture, prevent it.
            5) If it's possible to build a deadly tessera (ex: o w w w w o), build one.
            6) If it's possible to block the opponent from building a deadly tessera, block it.
            7) If the player can make a capture, make the move that results in the most captured pairs.
            8) If the opponent can make a capture on their following turn, make the move that prevents the most captured pairs.
            9) If the player can build initiative with three of their stones already placed, do it.
                9a) Prioritize building four consecutive stones. If it isn't possible, return the location that results in three consecutive stones.  
            10) If the opponent can build initiative with three of their stones already placed on their following turn, block it.
            11) If the player can build initiative with two of their stones already placed, do it.
                11a) Prioritize building three consecutive stones. If it isn't possible, return the location that results in the least amount of consecutive stones (ex: w o * o w).
            12) If the opponent has placed two consecutive stones that can be captured, initiate a flank.
            13) If the player can build initiative with one of their stones already placed, do it.
                13a) The location returned is two locations away from where the stone is placed (ex: w o * o o).
            14) If the opponent can build initiative with one of their stones already placed on their following turn, block it.
                14a) This also is used to begin a player's initiative when they do not have any stones placed on the board.
            15) As a fail-safe, return any random empty location on the board. This is only used when the board is nearly full and none of the above moves apply.

Assistance Received: None
********************************************************************* */
%First play of the game must be played on J10.
optimal_play(_, _, 0, Location, Reasoning) :-
    Location = [9, 9],
    Reasoning = ' because the first stone of the game must be played on J10.'.

%Special case on the second turn of the first player.
optimal_play(GameState, _, 2, Location, Reasoning) :-
    find_handicap_play(GameState, Location),
    Reasoning = ' to play optimally within the handicap.'.

%Determining the optimal play based on the current game state.
optimal_play(GameState, Color, _, Location, Reasoning) :-
    %Get the name of the current player and opponent's stone color.
    get_next_player(GameState, PlayerName),
    opponent_color(Color, OpponentColor),
    
    %Obtain all the necessary sequences of board locations.
    get_all_sequences(5, SequencesOfFive),
    get_all_sequences(6, SequencesOfSix),
    
    %Search for specific sequences required for the strategy clauses.
    search_for_sequences(GameState, SequencesOfFive, 4, 1, Color, [], WinningSequences),
    search_for_sequences(GameState, SequencesOfFive, 4, 1, OpponentColor, [], PreventWinningSequences),
    search_for_sequences(GameState, SequencesOfSix, 3, 3, Color, [], DeadlyTesseraSequences),
    search_for_sequences(GameState, SequencesOfSix, 3, 3, OpponentColor, [], PreventDeadlyTesseraSequences),
    
    %Moves that result in a capture or prevent the opponent from making a capture.
    make_capture(GameState, Color, CaptureMove),
    make_capture(GameState, OpponentColor, PreventCaptureMove),
    
    %Moves that result in a win.
    make_winning_move(GameState, WinningSequences, CaptureMove, PreventCaptureMove, PlayerName, WinningMove),
    
    %Move that prevents the opponent from winning.
	prevent_winning_move(GameState, PreventWinningSequences, PreventCaptureMove, PlayerName, PreventWinningMove),

	%Move that creates a deadly tessera.
	find_deadly_tessera(GameState, DeadlyTesseraSequences, Color, DeadlyTesseraMove),

	%Move that prevents the opponent from making a deadly tessera.
	prevent_deadly_tessera(GameState, PreventDeadlyTesseraSequences, PreventDeadlyTesseraMove),

	%Move that builds initiative with 3 of the player's stones already placed.
	build_initiative(GameState, 3, Color, Color, BuildInitiative3Move),	

	%Move that counters initiative with 3 of the opponent's stones already placed.
	counter_initiative(GameState, 3, Color, CounterInitiative3Move),	

	%Move that builds initiative with 2 of the player's stones already placed.
	build_initiative(GameState, 2, Color, Color, BuildInitiative2Move),	

	%Move that initiates a flank on the opponent.
	counter_initiative(GameState, 2, Color, CounterInitiative2Move),	

	%Move that builds initiative with 1 of the player's stones already placed.
	build_initiative(GameState, 1, Color, Color, BuildInitiative1Move),	

	%Move that counters initiative with 1 of the opponent's stones already placed.
	counter_initiative(GameState, 1, Color, CounterInitiative1Move),	
    
    %Fail safe - Random move that should NEVER be used (just in case none of the above strategies are valid).
    get_random_play(GameState, RandomRow, RandomColumn),
    RandomMove = [RandomRow, RandomColumn],
    
    %Put all of the potential moves into a list.
    AllPotentialMoves = [WinningMove, PreventWinningMove, DeadlyTesseraMove, PreventDeadlyTesseraMove, CaptureMove, 
                         PreventCaptureMove, BuildInitiative3Move, CounterInitiative3Move, BuildInitiative2Move, 
                         CounterInitiative2Move, BuildInitiative1Move, CounterInitiative1Move, RandomMove],
    
    determine_optimal_play(AllPotentialMoves, Location, Reasoning).

/* *********************************************************************
Clause Name: find_handicap_play
Purpose: To find an optimal play within the handicap (when it is the second turn of the player that went first).
Parameters: GameState, a list representing the current state of the game.
            HandicapPlay, a list representing an optimal handicap play. This is what is returned from this clause.
Return Value: HandicapPlay (see parameter list).
Algorithm:  1) Generate all of the sequeunces of locations that needs to be checked.
            2) Find all possible optimal handicap plays through the search version of this clause (find_handicap_play/3) 
            3) Randomly select one of the possible handicap plays so that the computer builds in all directions.
Assistance Received: None
********************************************************************* */
find_handicap_play(GameState, HandicapPlay) :-
    %Find the sequences that may contain a handicap play.
    get_all_sequences(5, Sequences),
    search_for_sequences(GameState, Sequences, 1, 4, w, [], SearchResult),
    
    %Find all of the potential handicap plays.
    find_handicap_play(GameState, SearchResult, PossiblePlays),
    
    %Randomly select one of the potential plays so that the computer plays in all directions.
    length(PossiblePlays, PossiblePlaysLength),
    random(0, PossiblePlaysLength, RandomIndex),
    nth0(RandomIndex, PossiblePlays, HandicapPlay).

/* *********************************************************************
Clause Name: find_handicap_play
Purpose: To find an optimal play within the handicap (when it is the second turn of the player that went first). This is the clause that does the searching.
Parameters: GameState, a list representing the current state of the game.
            A list, representing the sequences of locations on the board that need to be checked.
            PossiblePlays, a return list representing all of the possible optimal handicap plays. This is what is returned from this clause.
Return Value: PossiblePlays (see parameter list).
Algorithm:
            1) Recursively loop through each of the sequences of locations passed to this clause.
            2) For each sequence of locations, extract the first and last locations of the sequence.
            3) If the first or last location is not empty, meaning the sequence is in the format w o o o o or o o o o w:
                3a) If the first location is not empty (the sequence is w o o o o), add the 4th location of the sequeunce to the return list (ex: w o o * o).
                    Recursively call this clause to search the rest of the sequences.
                3b) If the last location is not empty (the sequence is - - - - W), add the 2nd location of the sequence to the return list (ex: w * o o W).
                    Recursively call this clause to search the rest of the sequeunces.
            4) Otherwise continue searching the rest of the sequences through recursion.
            5) Once all sequences have been checked, return the list of possible handicap plays.
Assistance Received: None
********************************************************************* */
%Base case of the searching clause.
find_handicap_play(_, [], []).

%Searching for the pattern w o o * o.
find_handicap_play(GameState, [Sequence | RestSequences], [PossiblePlay | RestPossiblePlays]) :-
    %Extracting the first location in the sequence.
    nth0(0, Sequence, FirstLocation),
    nth0(0, FirstLocation, Row),
    nth0(1, FirstLocation, Col),
    
    %Searching for the pattern w o o * o where * is a possible handicap play.
    at(GameState, Row, Col, AtLocation),
    AtLocation == 'w',
    
    %The return location is the 4th location in the sequence.
    nth0(3, Sequence, PossiblePlay),
    
    %Recursively search the rest of the sequences.
    find_handicap_play(GameState, RestSequences, RestPossiblePlays).
    
%Searching for the pattern o * o o w.
find_handicap_play(GameState, [Sequence | RestSequences], [PossiblePlay | RestPossiblePlays]) :-
    %Extracting the last location in the sequence (the sequence is of length 5).
    nth0(4, Sequence, FirstLocation),
    nth0(0, FirstLocation, Row),
    nth0(1, FirstLocation, Col),
    
    %Searching for the pattern o * o o w where * is a possible handicap play.
    at(GameState, Row, Col, AtLocation),
    AtLocation == 'w',
  
    %The return location is the 2nd location in the sequence.
    nth0(1, Sequence, PossiblePlay),
    
    %Recursively search the rest of the sequences.
    find_handicap_play(GameState, RestSequences, RestPossiblePlays).

%There was no handicap play found in the current sequence, so recursively search the rest.
find_handicap_play(GameState, [_ | RestSequences], PossiblePlays):-
    find_handicap_play(GameState, RestSequences, PossiblePlays).

/* *********************************************************************
Clause Name: get_all_sequences
Purpose: To get all valid sequences of locations on the board of a provided distance, in all directions.
Parameters: Distance, an integer representing the length of sequences of locations to generate.
            AllSequences, a return list representing the generated sequences. This is what is returned from this clause.
Return Value: AllSequences (see parameter list).
Algorithm:  1) Generate all of the sequences in the horizontal direction.
            2) Generate all of the sequences in the vertical direction.
            3) Generate all of the sequences in the main-disagonal direction.
            4) Generate all of the sequences in the anti-diagonal direction.
            5) Append all of the sequences and return a single list.
            6) Filter out invalid sequences and return the list of valid sequences. 
Assistance Received: None
********************************************************************* */
get_all_sequences(Distance, AllSequences) :-
    all_board_locations(0, 0, BoardLocations),

    %Horizontal sequences.
    get_sequences_in_direction(BoardLocations, 0, 1, Distance, Horizontal),

    %Vertical sequences.
    get_sequences_in_direction(BoardLocations, 1, 0, Distance, Vertical),

    %Main-diagonal sequences.
    get_sequences_in_direction(BoardLocations, 1, 1, Distance, MainDiagonal),

    %Anti-diagonal sequences.
    get_sequences_in_direction(BoardLocations, 1, -1, Distance, AntiDiagonal),

    %Concatenate the lists into one big list.
    append(Horizontal, Vertical, HV),
    append(HV, MainDiagonal, HVM),
    append(HVM, AntiDiagonal, UnfilteredSequences),

    %Filter out the invalid sequences.
    filter_sequences(UnfilteredSequences, AllSequences).

/* *********************************************************************
Clause Name: get_sequences_in_direction
Purpose: To get all of the possible sequences of a provided distance in a provided direction.
Parameters: A list representing all valid board locations on the board.
            RowChange, an integer representing the directional change applied to each row.
            ColChange, an integer representing the directional change applied to each column.
            Distance, an integer representing the length of sequences to generate.
            A return list, representing all of the generated sequences. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm:  1) Recursively loop through each board location on the board.
            2) Generate a sequences in the provided direction starting from the current location being evaluated (see get_sequence clause).
            3) Once all board locations have been checked, stop the recursion and return the list of sequences.
Assistance Received: None
********************************************************************* */
%Base case.
get_sequences_in_direction([], _, _, _, []).

%Recursive case.
get_sequences_in_direction([[Row, Column] | RestLocations], RowChange, ColChange, Distance, [Sequence | RestSequences]) :-
    get_sequence(Row, Column, RowChange, ColChange, Distance, Sequence),
    get_sequences_in_direction(RestLocations, RowChange, ColChange, Distance, RestSequences).

/* *********************************************************************
Clause Name: search_for_sequences
Purpose: To search for sequences that have a specific number of stones already placed and a specific number of empty locations. Used for determining optimal plays.
Parameters: GameState, a list representing the current state of the game.
            A list, representing all of the sequences of locations that needs to be searched.
            TargetStoneCount, an integer representing how many placed stones to search for within each sequence.
            TargetEmptyCount, an integer representing how many empty locations to search for within each sequence.
            Color, a character representing the color of stone that is being searched for.
            PartialList, a list representing a temporary list to temporarily store found sequences.
            ResultList, a list of all the found sequences of locations. This is what is returned from this clause.
Return Value: ResultList (see parameter list).
Algorithm:  1) Recursively search through all of the sequences passed to this clause.
            2) For each sequence, determine the number of stone placed as well as the number of empty locations within the sequence.
            3) If the number of stones placed and empty locations matches the parameters passed to this clause, add the sequence to the return list (see add_to_result).
            4) Once all sequences have been searched, return the list of found sequences if any exist.
Assistance Received: None
********************************************************************* */
%Base case.
search_for_sequences(_, [], _, _, _, CompletedList, ResultList):-
    ResultList = CompletedList.

search_for_sequences(GameState, [CurrentSequence | RestSequences], TargetStoneCount, TargetEmptyCount, Color, PartialList, ResultList) :-
    %Find the number of stones placed in the sequence.
    stone_count_in_sequence(GameState, CurrentSequence, Color, FoundStonesPlaced),
    
    %Find the number of empty locations in the sequence.
    find_empty_locations(GameState, CurrentSequence, EmptyLocations),
    length(EmptyLocations, FoundEmptyCount),
    
    %Determine whether or not the sequence should be added to the result list.
    add_to_result(PartialList, CurrentSequence, TargetStoneCount, TargetEmptyCount, FoundStonesPlaced, FoundEmptyCount, PartialResultList),
    
    %Search through the rest of the sequences
    search_for_sequences(GameState, RestSequences, TargetStoneCount, TargetEmptyCount, Color, PartialResultList, ResultList).

/* *********************************************************************
Clause Name: stone_count_in_sequence
Purpose: To determine the number of placed stones of a provided color in a provided sequence of locations.
Parameters: GameState, a list representing the current state of the game.
            A list, representing a sequence of board locations in the format [[Row0, Col0], [Row1, Col1], ...]
            Color, an atom representing the stone color being checked.
            StonesPlaced, an integer representing the total number of stones placed in the sequence of locations. This is what is returned from this clause.
Return Value: StonesPlaced (see parameter list).
Algorithm:  1) Recursively loop through each location within the provided sequence.
            2) If there is a stone of the provided color placed at the location being evaluated, increment the return value and recursively call this clause.
            3) Once there are no more locations to search in the sequence, return the number of stones that were found.
Assistance Received: None
********************************************************************* */
%Base case.
stone_count_in_sequence(_, [], _, 0).

%Recursive case - there is a stone of "Color" at the location being evaluated.
stone_count_in_sequence(GameState, [[Row, Col] | RestLocations], Color, StonesPlaced) :-
    at(GameState, Row, Col, AtLocation),
    AtLocation == Color,
    stone_count_in_sequence(GameState, RestLocations, Color, RestStonesPlaced),
    StonesPlaced is RestStonesPlaced + 1.

%Recursive case - there is not a stone of "Color" at the location being evaluated.
stone_count_in_sequence(GameState, [_ | RestLocations], Color, StonesPlaced) :-
    stone_count_in_sequence(GameState, RestLocations, Color, StonesPlaced).

/* *********************************************************************
Clause Name: find_empty_locations
Purpose: To find all of the empty locations within a sequence of locations.
Parameters: GameState, a list representing the current state of the game.
            A list, representing a sequence of board locations in the format [[Row0, Col0], [Row1, Col1], ...].
            EmptyLocations, a return list containing all of the empty locations within the provided sequence of locations. This is what is returned from this clause.
Return Value: EmptyLocations (see parameter list).
Algorithm:  1) For each location within the sequence, determine if the location is empty (using the at clause).
            2) If the location is empty, add the location to the return list.
            3) Recursively search through each location within the provided sequence until all have been checked. 
Assistance Received: None
********************************************************************* */
%Base case.
find_empty_locations(_, [], []).

%Recursive case - the location being evaluated is empty.
find_empty_locations(GameState, [[Row, Col] | RestLocations], [FirstEmptyLocation | RestEmptyLocations]) :-
    at(GameState, Row, Col, AtLocation),
    AtLocation == o,
    FirstEmptyLocation = [Row, Col],
    find_empty_locations(GameState, RestLocations, RestEmptyLocations).
  
%Recursive case - the location being evaluated is not empty.
find_empty_locations(GameState, [_ | RestLocations], EmptyLocations) :-
    find_empty_locations(GameState, RestLocations, EmptyLocations).

/* *********************************************************************
Clause Name: add_to_result
Purpose: Helper clause to the search_for_sequences clause to add found sequences to the return list. Sequences are only added if they meet the required stone and empty counts.
Parameters: CurrentList, a list that will potentially have an element added to it.
            ToAdd, the element that is being added to the list.
            TargetStoneCount, an integer representing how many placed stones to search for within each sequence.
            TargetEmptyCount, an integer representing how many empty locations to search for within each sequence.
            FoundStoneCount, an integer representing how many placed stones were found in the sequence.
            FoundEmptyCount, an integer representing how many empty locations were found in the sequence.
            Result, the resulting list containing the potentially added element (may or may not have been added). This is what is returned from this clause.
Return Value: Result (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
add_to_result(CurrentList, ToAdd, TargetStoneCount, TargetEmptyCount, FoundStoneCount, FoundEmptyCount, Result) :-
    TargetStoneCount == FoundStoneCount,
    TargetEmptyCount == FoundEmptyCount,
    append(CurrentList, [ToAdd], Result).

add_to_result(CurrentList, _, _, _, _, _, CurrentList).

/* *********************************************************************
Clause Name: make_capture
Purpose: To find the most optimal location that results in the most captured pairs, if any exist.
Parameters: GameState, a list representing the current state of the game.
            Color, an atom representing the stone color being checked.
            BestCapture, a list in the format [NumCaptures, [Row, Col]] representing the most optimal capture location (if one exists). This is what is returned from this clause.
Return Value: BestCapture (see parameter list).
Algorithm:  1) Find all of the possible capture locations and resulting number of captures that would occur if placed there (see find_all_captures).
            2) Out of all the possible locations, find the location that results in the most captures so that the most points are scored (see find_most_captures).
            3) Return the location the results in the most captures.
Assistance Received: None
********************************************************************* */
make_capture(GameState, Color, BestCapture) :-
    all_board_locations(0, 0, Locations),
    generate_all_capture_sequences(Locations, AllCaptureSequences),
    find_all_captures(GameState, Locations, AllCaptureSequences, Color, PossibleCaptures),
    find_most_captures(PossibleCaptures, BestCapture).

/* *********************************************************************
Clause Name: generate_all_capture_sequences
Purpose: To generate all of the capture sequences on the board the need to be checked.
Parameters: A list, representing all board locations.
            A return list, representing all of the capture sequences that need to be checked on the board. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm:  1) Recursively loop through each of the board locations on the board.
            2) For each board location, generate and filter the capture sequences for that location (see generate_capture_sequences and filter_sequences)
            3) Once all board locations have been seen, stop the recursion and return the list of generated capture sequences.
Assistance Received: None
********************************************************************* */
%Base case
generate_all_capture_sequences([], []).

%Recursive case
generate_all_capture_sequences([[Row, Col] | RestLocations], [CaptureSequence | RestCaptureSequences]) :-
    generate_all_directions(Directions),
    generate_capture_sequences(Row, Col, Directions, UnfilteredCaptureSequences),
    filter_sequences(UnfilteredCaptureSequences, CaptureSequence),
    generate_all_capture_sequences(RestLocations, RestCaptureSequences).

/* *********************************************************************
Clause Name: find_all_captures
Purpose: To find all possible capture locations on the board, along with how many captures occur if a stone is placed there.
Parameters: GameState, a list representing the current state of the game.
            A list, representing all board locations on the board in the format [[Row0, Col0], [Row1, Col1], ...].
            A list of all capture sequences that needs to be checked on the board.
            Color, an atom representing the stone color being checked.
            AllPossibleCaptures, a return list in the format [[NumCaptures, Location0], [NumCaptures, Location1], ...] that represents all possible capture locations. This is what is returned from this clause.
Return Value: AllPossibleCaptures (see parameter list).
Algorithm: None
              1) Recursively search through each of the possible valid board locations.
              2) Determine the number of captures that would occur if a stone is placed at the current board location being evaluated (see find_captures_at_location).
              3) If the number of captures is greater than 0, add this location and number of captures to the return list.
              4) Once all board locations have been searched, return the list of locations that result in captures, if any exist.
Assistance Received: None
********************************************************************* */
%Base case.
find_all_captures(_, [], _, _, []).

%Recursive case, a capture was found at the location.
find_all_captures(GameState, [Location | RestLocations], [CaptureSequences | RestCaptureSequences], Color, [[NumCaptures, Location] | RestPotentialCaptures]) :-    
    %The location must be empty for a capture to occur.
    nth0(0, Location, Row),
    nth0(1, Location, Col),
    at(GameState, Row, Col, AtLocation),
    AtLocation == o,

    find_captures_at_location(GameState, CaptureSequences, Color, NumCaptures),

    %If there is at least one capture possible at the location, the location should be added to the return list.
    NumCaptures > 0,
    find_all_captures(GameState, RestLocations, RestCaptureSequences, Color, RestPotentialCaptures).

%Recursive case, a capture was not found at the location.
find_all_captures(GameState, [_ | RestLocations], [_ | RestCaptureSequences], Color, AllPossibleCaptures) :-
    find_all_captures(GameState, RestLocations, RestCaptureSequences, Color, AllPossibleCaptures).

/* *********************************************************************
Clause Name: find_captures_at_location
Purpose: To find the number of captures that would occur at a specific location if a stone of a provided color is placed there.
Parameters: GameState, a list representing the current state of the game.
            A list, containing capture sequences (each containing three locations on the board). The format of the list is: [[[Row1, Col1], [Row2, Col2], [Row3, Col3]].
            Color, an atom representing the stone color being checked.
            NumCaptures, an integer represnting the number of captures that would occur if a stone is placed at a location. This is what is returned from this clause.
Return Value: NumCaptures (see parameter list).
Algorithm:
              1) Recursively search through each capture sequence.
              2) For each capture sequence, extract the first, second, and third locations (capture sequences are sequences of 3 locations away from the current location).
                 Also, determine and store the opponent's stone color.
              3) If the stones in the sequence are in the pattern O O P, that means a capture can occur. Recursively call the clause with numCaptures incremented by 1.
              4) Otherwise, continuing searching the rest of the capture sequences.
              5) After all capture sequences have been searched, return the number of captures that would occur.
Assistance Received: None
********************************************************************* */
%Base case.
find_captures_at_location(_, [], _, 0).

%A capture was found at the current capture sequence.
find_captures_at_location(GameState, [[[Row1, Col1], [Row2, Col2], [Row3, Col3]] | RestSequences], Color, NumCaptures) :-
    % Find the opponent's color.
    opponent_color(Color, OpponentColor),

    % Find what is at each location.
    at(GameState, Row1, Col1, AtLocation1),
    at(GameState, Row2, Col2, AtLocation2),
    at(GameState, Row3, Col3, AtLocation3),

    %If the stones are in the pattern * O O P, where O is the opponent's stone and P is the player's stone, a capture can be made.
    AtLocation1 = OpponentColor,
    AtLocation2 = OpponentColor,
    AtLocation3 = Color,

    %Continue searching the rest of the capture sequences, and incremement the number of captures found by 1.
    find_captures_at_location(GameState, RestSequences, Color, NewNumCaptures),
    NumCaptures is NewNumCaptures + 1.

%A capture wasn't found at the current capture sequence, continue searching the rest of them.
find_captures_at_location(GameState, [_ | RestSequences], Color, NumCaptures) :-
    find_captures_at_location(GameState, RestSequences, Color, NumCaptures).

/* *********************************************************************
Clause Name: find_most_captures
Purpose: To find the location on the board that results in the most captures, given a list of potential capture locations.
Parameters: A list, containing all potential plays that result in a capture.
            A return list, containing the capture information that results in the maximum number of captures in the format [NumCaptures, Location]. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm:  1) If the first provided list is empty, return an empty list.
            2) If the first provided list only has one element, that one element is the max.
            3) Otherwise, recursively call this clause and use the determine_max helper clause to find the maximum element. 
Assistance Received: https://www.youtube.com/watch?v=0ueZYr-6RQ8 - Video explaining how to find the max element in a list.
                     https://stackoverflow.com/questions/19798844/finding-the-max-in-a-list-prolog
********************************************************************* */
%Base case for when there are no capture locations.
find_most_captures([], []).

%base case for when there is only one capture location.
find_most_captures([FirstElement], FirstElement).

%Recursively search through the list for the location that results in the most captures.
find_most_captures([FirstElement, SecondElement | Rest], Max) :-
    find_most_captures([SecondElement | Rest], MaxRest),
    determine_max(FirstElement, MaxRest, Max).

/* *********************************************************************
Clause Name: determine_max
Purpose: Helper clause for the find_most_captures clause to help find the maximum number of captures in the capture list.
Parameters: FirstElement, a list containing capture information for a single location.
            SecondElement, another list containing capture information for a different location.
            A result list (either the first or second element), which is the capture location that results in the most captures. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: https://www.youtube.com/watch?v=0ueZYr-6RQ8 - Video explaining how to find the max element in a list.
********************************************************************* */
determine_max(FirstElement, SecondElement, FirstElement) :-
    nth0(0, FirstElement, CaptureCountFirstElement),
    nth0(0, SecondElement, CaptureCountSecondElement),
    CaptureCountFirstElement >= CaptureCountSecondElement.

determine_max(FirstElement, SecondElement, SecondElement) :-
    nth0(0, FirstElement, CaptureCountFirstElement),
    nth0(0, SecondElement, CaptureCountSecondElement),
    CaptureCountFirstElement < CaptureCountSecondElement.

/* *********************************************************************
Clause Name: make_winning_move
Purpose: To find a move, if any exist, the results in the player winning the round.
Parameters: GameState, a list representing the current state of the game.
            WinningSequences, a list of sequences of locations representing potential winning moves.
            CapturePlay, a list containing the most optimal capture play, in the format [NumCaptures, Location].
            PreventCapturePlay, a list containing the most optimal prevent capture play, in the format [NumCaptures, Location].
            An atom (human or computer), representing which player is calling this clause.
            PossiblePlay, a list representing a possible winning move and win explanation, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) First, check if it is possible to make five consecutive stones on the board.
            2) If there are multiple locations that would result in five conscecutive stones on the board:
                2a) If the player is not at risk of being captured on their following turn, and they can capture the opponent's stones, opt to make the capture and delay the win.
                2b) Otherwise, just return a location that results in five consecutive stones to win the round.
            3) If there is only one location that results in five consecutive stones, return this location.
            4) If there are no locations that result in five consecutive stones, check if the player can win by achieving five captured pairs.
            5) If it's possible to win via capture, return this location. Otherwise, return an empty list.
Assistance Received: None
********************************************************************* */
%Delaying the win for additional points.
make_winning_move(_, WinningSequences, CapturePlay, PreventCapturePlay, _, PossiblePlay) :-
    WinningSequences \= [],
    length(WinningSequences, WinningSequencesLength),
    %If there are multiple locations that would result in five consecutive stones, the win can potentially be delayd.
    WinningSequencesLength > 1,
    %Check to see if there are any captures that could be made and that the player is not at risk of being captured on their following turn.
    CapturePlay \= [],
    PreventCapturePlay == [],
    %Delay the win to score additional points (Note: Capture play is in the format [NumCaptures, Location]).
    nth0(1, CapturePlay, Location),
    PossiblePlay = [Location, ' to delay the win and score additional points via capture.'].

%Winning via five consecutive stones.
make_winning_move(GameState, WinningSequences, _, _, _, PossiblePlay) :-
    WinningSequences \= [], 
    %Find the empty location in the winning sequence.
    nth0(0, WinningSequences, WinningSequence),
    find_empty_locations(GameState, WinningSequence, EmptyLocations),
    %Note: There will always be one empty location in the winning sequence.
    nth0(0, EmptyLocations, EmptyLocation),
    %Return the location that results in five consecutive stones to win the round.
    PossiblePlay = [EmptyLocation, ' to win by getting five consecutive stones.'].

%Winning via five or more captured pairs (human is calling this).
make_winning_move(GameState, _, CapturePlay, _, human, PossiblePlay) :-
    CapturePlay \= [],
    nth0(0, CapturePlay, NumCaptures),
    get_human_captured(GameState, HumanCapturedPairCount),
    PotentialCapturedPairCount is NumCaptures + HumanCapturedPairCount,
    PotentialCapturedPairCount >= 5,
    nth0(1, CapturePlay, ReturnLocation),
    PossiblePlay = [ReturnLocation, ' to win by having at least five captured pairs.'].

%Winning via five or more captured pairs (computer is calling this).
make_winning_move(GameState, _, CapturePlay, _, computer, PossiblePlay) :-
    CapturePlay \= [],
    nth0(0, CapturePlay, NumCaptures),
    get_computer_captured(GameState, ComputerCapturedPairCount),
    PotentialCapturedPairCount is NumCaptures + ComputerCapturedPairCount,
    PotentialCapturedPairCount >= 5,
    nth0(1, CapturePlay, ReturnLocation),
    PossiblePlay = [ReturnLocation, ' to win by having at least five captured pairs.'].
    
%Base case - no winning moves found.
make_winning_move(_, _, _, _, _, []).

/* *********************************************************************
Clause Name: prevent_winning_move
Purpose: To find a location on the board that prevents the opponent from winning on their following turn, either by five consecutive stones or by capture.
Parameters: GameState, a list representing the current state of the game.
            PreventWinningSequences, a list of sequences of locations representing potential prevent winning moves.
            PreventCapturePlay, a list containing the most optimal prevent capture play, in the format [NumCaptures, Location].
            An atom (human or computer), representing which player is calling this clause.
            PossiblePlay, a list representing a possible prevent winning move and win explanation, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) First, check if it is possible to prevent the opponent from make five consecutive stones on the board. If there is, return this location.
            2) If there are no locations that result in five consecutive stones, check if the player can prevent the opponent from achieving five captured pairs. If they can, block the capture play.
            3) Otherwise, return an empty list.
Assistance Received: None
********************************************************************* */
%Blocking five consecutive stones.
prevent_winning_move(GameState, PreventWinningSequences, _, _, PossiblePlay) :-
    PreventWinningSequences \= [],
    %If the opponent can make five consecutive stones, prevent it.
    nth0(0, PreventWinningSequences, PreventWinningSequence),
    find_empty_locations(GameState, PreventWinningSequence, EmptyLocations),
    nth0(0, EmptyLocations, EmptyLocation),
    PossiblePlay = [EmptyLocation, ' to prevent the opponent from getting five consecutive stones.'].

%Preventing five captured pairs, the human is calling this clause.
prevent_winning_move(GameState, _, PreventCapturePlay, human, PossiblePlay) :-
    PreventCapturePlay \= [],
    %Determine if it is possible for the computer to win via their best capture.
    get_computer_captured(GameState, ComputerCaptured),
    nth0(0, PreventCapturePlay, NumCaptures),
    PotentialOpponentCaptures is ComputerCaptured + NumCaptures,
    %If the opponent can win on their next turn via capture, block it.
    PotentialOpponentCaptures >= 5,
    nth0(1, PreventCapturePlay, ReturnLocation),
    PossiblePlay = [ReturnLocation, ' to prevent the opponent from getting five captured pairs.'].

%Preventing five captured pairs, the computer is calling this clause.
prevent_winning_move(GameState, _, PreventCapturePlay, computer, PossiblePlay) :-
    PreventCapturePlay \= [],
    %Determine if it is possible for the computer to win via their best capture.
    get_human_captured(GameState, HumanCaptured),
    nth0(0, PreventCapturePlay, NumCaptures),
    PotentialOpponentCaptures is HumanCaptured + NumCaptures,
    %If the opponent can win on their next turn via capture, block it.
    PotentialOpponentCaptures >= 5,
    nth0(1, PreventCapturePlay, ReturnLocation),
    PossiblePlay = [ReturnLocation, ' to prevent the opponent from getting five captured pairs.'].

%Base case, no prevent winning moves.
prevent_winning_move(_, _, _, _, []).

/* *********************************************************************
Clause Name: find_deadly_tessera
Purpose: To find a location on the board that builds a deadly tessera for the player.
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where a possible deadly tessera could be formed.
            DangerColor, the stone color that needs to be checked for risk of capture.
            PossiblePlay, a list representing a possible location on the board that creates a deadly tessera, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively search through each of the provided sequences.
            2) For each sequence, determine and store the empty indices of that sequence.
            3) If two of the empty indices in the sequence or 0 and 5 (representing the ends of the sequence), a deadly tessera can be formed.
                3a) The location that forms the deadly tessera is the middle empty index (ex: o w w * w o). If this location does not put the player at risk of being
                    captured, return this location.
            4) Otherwise continue searching the rest of the sequences recursively.
            5) An empty list is returned if no safe deadly tessera placements are found.
Assistance Received: None
********************************************************************* */
%Base case - no deadly tesseras found.
find_deadly_tessera(_, [], _, []).

%Searching for a deadly tessera.
find_deadly_tessera(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    %Deadly tesseras are in the form o w w * w o, where the empty indices are on the ends of the sequence of six locations.
    nth0(0, EmptyIndices, FirstEmptyIndex),
    nth0(1, EmptyIndices, SecondEmptyIndex),
    nth0(2, EmptyIndices, ThirdEmptyIndex),
    FirstEmptyIndex == 0,
    ThirdEmptyIndex == 5,
    %If a deadly tessera can be formed, return the location if it does not put the player at risk of being captured.
    %The location being returned is the second empty index in the sequence (so o w w w w o is built).
    nth0(SecondEmptyIndex, Sequence, ReturnLocation),
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%A deadly tessera was not found, continue searching the rest of the possible sequences.
find_deadly_tessera(GameState, [_ | RestSequences], DangerColor, PossiblePlay) :-
    find_deadly_tessera(GameState, RestSequences, DangerColor, PossiblePlay).

/* *********************************************************************
Clause Name: find_empty_indices
Purpose: To find all of the empty indices within a sequence of locations.
Parameters: GameState, a list representing the current state of the game.
            A list, representing a sequence of board locations in the format [[Row0, Col0], [Row1, Col1], ...].
            Index, an integer representing the current index in the sequence of locations being evaluated.
            EmptyIndices, a return list containing all of the empty indices within the provided sequence of locations. This is what is returned from this clause.
Return Value: EmptyIndices (see parameter list).
Algorithm:  1) For each location within the sequence, determine if the location is empty (using the at clause).
            2) If the location is empty, add the current index being evaluated to the return list and increment the index by one.
            3) Recursively search through each location within the provided sequence until all have been checked incrementing the index by one each time. 
Assistance Received: None
********************************************************************* */
%Base case.
find_empty_indices(_, [], _, []).

%Recursive case - the location being evaluated is empty.
find_empty_indices(GameState, [[Row, Col] | RestLocations], Index, [FirstEmptyIndex | RestEmptyIndices]) :-
    at(GameState, Row, Col, AtLocation),
    AtLocation == o,
    FirstEmptyIndex = Index,
    NewIndex is Index + 1,
    find_empty_indices(GameState, RestLocations, NewIndex, RestEmptyIndices).
    
%Recursive case - the location being evaluated is not empty.
find_empty_indices(GameState, [_ | RestLocations], Index, EmptyIndices) :-
    NewIndex is Index + 1,
    find_empty_indices(GameState, RestLocations, NewIndex, EmptyIndices).

/* *********************************************************************
Clause Name: no_danger_of_capture
Purpose: To determine if placing a stone at a provided location would not put the player at risk of being captured on their following turn.
Parameters: GameState, a list representing the current state of the game.
            A list, in the format [Row, Col] representing a location on the board a stone could be placed on.
            Color, an atom representing the player's stone color.
Return Value: None
Algorithm: None
Assistance Received: None
********************************************************************* */
no_danger_of_capture(GameState, [Row, Col], Color) :-
    %Check for danger in all 8 directions. If this clause passes, there is no danger. If this clause fails, there is danger.
    check_danger(GameState, [Row, Col], [0,1], Color),
    check_danger(GameState, [Row, Col], [0,-1], Color),
    check_danger(GameState, [Row, Col], [1,0], Color),
    check_danger(GameState, [Row, Col], [-1,0], Color),
    check_danger(GameState, [Row, Col], [1,1], Color),
    check_danger(GameState, [Row, Col], [-1,-1], Color),
    check_danger(GameState, [Row, Col], [1,-1], Color),
    check_danger(GameState, [Row, Col], [-1,1], Color).

/* *********************************************************************
Clause Name: check_danger
Purpose: To check if there is risk of being captured at a provided location in a provided direction.
Parameters: GameState, a list representing the current state of the game.
            A list, in the format [Row, Col] representing a location on the board a stone could be placed on.
            A list, in the format [RowChange, ColChange] representing the directional change to be applied to each row and column respectively.
            Color, an atom representing the player's stone color.
Return Value: None
Algorithm:  1) Generate two locations going in the current direction being evaluated and one location going in the opposite direction.
            2) If any of the generated locations are invalid in terms of board constraints, this direction is automatically safe.
            3) If all locations generated in Step 2 are valid:
                3a) Check if the stones are either in the pattern:  o * P O or O * P o (P is current player, O is opponent, o is an empty location, and * is the location
                passed to this clause). If this pattern exists, this clause will fail.
            4) Otherwise, this clause will be successful.
Assistance Received: None
********************************************************************* */
%Checking if the first location is invalid.
check_danger(_, [Row, Col], [RowChange, ColChange], _) :-
    %Generating the opposite direction.
    OppositeRowChange is RowChange * -1,
    OppositeColChange is ColChange * -1,
    OneBehindRow is Row + OppositeRowChange,
    OneBehindCol is Col + OppositeColChange,
    %If any of the generated locations are invalid, the location is automatically safe.
    invalid_indices(OneBehindRow, OneBehindCol).

%Checking if the second location is invalid.
check_danger(_, [Row, Col], [RowChange, ColChange], _) :-
    OneAwayRow is Row + RowChange,
    OneAwayCol is Col + ColChange,
    %If any of the generated locations are invalid, the location is automatically safe.
    invalid_indices(OneAwayRow, OneAwayCol).

%Checking if the third location is invalid.
check_danger(_, [Row, Col], [RowChange, ColChange], _) :-
    OneAwayRow is Row + RowChange,
    OneAwayCol is Col + ColChange,
    TwoAwayRow is OneAwayRow + RowChange,
    TwoAwayCol is OneAwayCol + ColChange,
    %If any of the generated locations are invalid, the location is automatically safe.
    invalid_indices(TwoAwayRow, TwoAwayCol).
    
%Looking for patterns that would put the player at risk of being captured.
check_danger(GameState, [Row, Col], [RowChange, ColChange], Color) :-
    opponent_color(Color, OpponentColor),
    %Generating the opposite direction.
    OppositeRowChange is RowChange * -1,
    OppositeColChange is ColChange * -1,
    %To find risk of potential capture, two locations going in the current direction being 
    %evaluated, and one location going in the opposite direction needs to be stored.
    OneAwayRow is Row + RowChange,
    OneAwayCol is Col + ColChange,
    TwoAwayRow is OneAwayRow + RowChange,
    TwoAwayCol is OneAwayCol + ColChange,
    OneBehindRow is Row + OppositeRowChange,
    OneBehindCol is Col + OppositeColChange,
    %Extract what is at each location.
    at(GameState, OneAwayRow, OneAwayCol, OneAwayResult),
    at(GameState, TwoAwayRow, TwoAwayCol, TwoAwayResult),
    at(GameState, OneBehindRow, OneBehindCol, OneBehindResult),
    %CHECK FOR DANGER. If this clause succeeds, that means there is no danger. It will fail otherwise.
    %If there is a pattern O * P o (P is current player, O is opponent, o is an empty location), the location puts the player at risk of being captured and this will fail.
    (OneBehindResult \= OpponentColor ; OneAwayResult \= Color ; TwoAwayResult \= o),
    %If there is a pattern o * P O (P is current player, O is opponent, o is an empty location), the location puts the player at risk of being captured and this will fail.
    (OneBehindResult \= o ; OneAwayResult \= Color ; TwoAwayResult \= OpponentColor).

/* *********************************************************************
Clause Name: invalid_indices
Purpose: To determine if a pair of row/column indices is invalid in terms of board constraints or not.
Parameters: Row, an integer representing the row of a location on the board.
            Column, an integer representing the column of a location on the board.
Return Value: None
Algorithm: None
Assistance Received: None
********************************************************************* */
invalid_indices(Row, _) :-
    Row < 0.

invalid_indices(Row, _) :-
    Row > 18.

invalid_indices(_, Col) :-
    Col < 0.

invalid_indices(_, Col) :-
    Col > 18.

/* *********************************************************************
Clause Name: prevent_deadly_tessera
Purpose: To find a location on the board that prevents the opponent from building a deadly tessera for the player.
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where a possible deadly tessera could be formed.
            PossiblePlay, a list representing a possible location on the board that prevents the opponent from building a deadly tessera, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively search through each of the provided sequences.
            2) For each sequence, determine and store the empty indices of that sequence.
            3) If two of the empty indices in the sequence or 0 and 5 (representing the ends of the sequence), a deadly tessera can be formed.
                3a) The location that forms the deadly tessera is the middle empty index (ex: o w w * w o). Return this location since deadly tesseras must be blocked.
            4) Otherwise continue searching the rest of the sequences recursively.
            5) An empty list is returned if no safe deadly tessera placements are found.
********************************************************************* */
%Base case - no deadly tesseras found.
prevent_deadly_tessera(_, [], []).

%A deadly tessera was found.
prevent_deadly_tessera(GameState, [Sequence | _], PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    %Deadly tesseras are in the form o w w w w o, where the empty indices are on the ends of the sequence of six locations.
    nth0(0, EmptyIndices, FirstEmptyIndex),
    nth0(1, EmptyIndices, SecondEmptyIndex),
    nth0(2, EmptyIndices, ThirdEmptyIndex),
    FirstEmptyIndex == 0,
    ThirdEmptyIndex == 5,
    %If a deadly tessera can be formed, return the location. It doesn't matter if it puts the player at risk of being captured, it still needs to be blocked.
    %The location being returned is the second empty index in the sequence (so o w w w w o is built).
    nth0(SecondEmptyIndex, Sequence, ReturnLocation),
    PossiblePlay = ReturnLocation.

%A deadly tessera was not found, continue searching the rest of the possible sequences.
prevent_deadly_tessera(GameState, [_ | RestSequences], PossiblePlay) :-
    prevent_deadly_tessera(GameState, RestSequences, PossiblePlay).

/* *********************************************************************
Clause Name: build_initiative
Purpose: To find the most optimal location to build initiative for the player.
Parameters: GameState, a list representing the current state of the game.
            An integer (1-3), representing the number of stones placed by the current player in an open five consecutive locations to search for.
            PlayerColor, an atom representing the stone color of the player to search for.
            DangerColor, an atom representing the stone color that would potentially be in danger of being captured on the following turn.
            Move, a list representing the most optimal build initiative move. This is what is returned from this clause.
Return Value: Move (see parameter list).
Algorithm:  1) Find all of the possible open consecutive five locations that satify the search conditions passed to this clause (using search_for_sequences).
            2) If the integer representing the number of stone already placed is 3:
                2a) Attempt to return a location that results in four consecutive stones (see four_consecutive), if it exists.
                2b) If it isn't possible to make four consecutive stones, return the location that results in three conscecutive stones, if it exists (see three_consecutive).
            3) If the integer representing the number of stone already placed is 2:
                3a) Attempt to return a location that results in three consecutive stones (see three_consecutive), if it exists.
                3b) If it isn't possible to make three consecutive stones, return the location that results in the least amount of consecutive 
                    stones (see find_middle_location_play and two_consecutive) to avoid capture risk.
            4) If the integer representing the number of stone already placed is 1:
                4a) Find all locations that are two away from a single placed stone (see find_two_locations_away). Return one of these locations.
Assistance Received: None
********************************************************************* */
%BUILD INITIATIVE 3.
build_initiative(GameState, 3, PlayerColor, DangerColor, Move) :-
    %First, generate the sequences that have at least 3 stones of the player's stone color and 2 empty locations.
    get_all_sequences(5, AllSequences),
    search_for_sequences(GameState, AllSequences, 3, 2, PlayerColor, [], SearchResult),
    
    %Attempt to build four consecutive stones.
    four_consecutive(GameState, SearchResult, DangerColor, FourConsecutivePlay),
    
    %Attempt to build three consecutive stones.
    three_consecutive(GameState, SearchResult, DangerColor, ThreeConsecutivePlay),
    
    %Determine the best move, if one exists.
    determine_build_initiative_3(FourConsecutivePlay, ThreeConsecutivePlay, Move).

%BUILD INITIATIVE 2.
build_initiative(GameState, 2, PlayerColor, DangerColor, Move) :-
    %First, generate the sequences that have at least 2 stones of the player's stone color and 3 empty locations.
    get_all_sequences(5, AllSequences),
    search_for_sequences(GameState, AllSequences, 2, 3, PlayerColor, [], SearchResult),
    
    %Attempt to build three consecutive stones.
    three_consecutive(GameState, SearchResult, DangerColor, ThreeConsecutivePlay),
    
    %Attempt to build a stone in the middle of a sequence (Ex: w o * o w)
    find_middle_location_play(GameState, SearchResult, DangerColor, MiddleLocationPlay),
    
    %Attempt to build two consecutive stones.
	two_consecutive(GameState, SearchResult, DangerColor, TwoConsecutivePlay),
    
    %Determine the best move, if one exists.
    determine_build_initiative_2(ThreeConsecutivePlay, MiddleLocationPlay, TwoConsecutivePlay, Move).

%BUILD INITIATIVE 1.
build_initiative(GameState, 1, PlayerColor, DangerColor, Move) :-
    %Find a location that is two locations away from the placed stone (and doesn't put the player at risk of being captured.
    find_two_locations_away(GameState, PlayerColor, DangerColor, Move).

/* *********************************************************************
Clause Name: four_consecutive
Purpose: To find if there is a location that would result in four consecutive stones, given sequences of locations to search.
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where four consecutive stones could potentially be formed.
            DangerColor, the stone color that needs to be checked for risk of capture.
            PossiblePlay, a list representing a possible location on the board that creates four consecutive stones, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively search through each of the provided sequences of locations.
            2) For each sequence, find the empty indices within the sequence (there will always be two when this clause is called).
            3) Test each empty index, and if placing a stone on any of them result in four consecutive stones (calculated through num_consecutive_if_placed),
               and placing a stone there does not put the player at risk of being captured, return this location.
            4) Otherwise, continue searching the rest of the sequences through recursion.
            5) If there are no locations found after all sequences are searched, return an empty list.
Assistance Received: None
********************************************************************* */
%Base case - no four consecutive plays were found.
four_consecutive(_, [], _, []).

%Checking the first empty index in the sequence of locations.
four_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(0, EmptyIndices, FirstEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, FirstEmptyIndex, FirstTotalConsecutive),
    %If the number of consecutive stones that would occur is 4, return this location.
    FirstTotalConsecutive == 4,
    nth0(FirstEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Checking the second empty index in the sequence of locations. 
four_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(1, EmptyIndices, SecondEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, SecondEmptyIndex, SecondTotalConsecutive),
    %If the number of consecutive stones that would occur is 4, return this location.
    SecondTotalConsecutive == 4,
    nth0(SecondEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Recursive case so that the rest of the sequences get checked.
four_consecutive(GameState, [_ | RestSequences], DangerColor, PossiblePlay) :-
    four_consecutive(GameState, RestSequences, DangerColor, PossiblePlay).

/* *********************************************************************
Clause Name: num_consecutive_if_placed
Purpose: To determine the number of consecutive stones that would occur if a stone is placed at a provided index of the sequence.
Parameters: GameState, a list representing the current state of the game.
            Sequence, a list representing a single sequence of locations.
            PlaceIndex, an integer representing the index of the sequence where the stone would potentially be placed.
            TotalConsecutive, an integer representing the total number of consecutive stones that would occur. This is what is returned from this clause.
Return Value: TotalConsecutive (see parameter list).
Algorithm:  1) Calculate the number of consecutive stones before the PlaceIndex in the sequence.  
            2) Calculate the number of consecutive stones after the PlaceIndex in the sequence.
            3) Return the number of consecutive stones before PlaceIndex + the number of consecutive stones after PlaceIndex + 1 (to represent the stone itself).
Assistance Received: None
********************************************************************* */
num_consecutive_if_placed(GameState, Sequence, PlaceIndex, TotalConsecutive) :-
    BeforeIndex is PlaceIndex - 1,
    AfterIndex is PlaceIndex + 1,
    %Find the number of consecutive stones before and after the place index.
    before_consecutive(GameState, Sequence, BeforeIndex, BeforeTotal),
    after_consecutive(GameState, Sequence, AfterIndex, AfterTotal),
    %The total consecutive stone count is the before sterak + after streak + 1 (the stone itself).
    TotalConsecutive is BeforeTotal + AfterTotal + 1.

/* *********************************************************************
Clause Name: before_consecutive
Purpose: To determine the number of consecutive stones from an index, up to the left end of a sequence. Helper clause for NumConsecutiveIfPlaced.
Parameters: GameState, a list representing the current state of the game.
            Sequence, a list representing a single sequence of locations.
            Index, an integer used to keep track of the index of the sequence that is being evaluated.
            TotalBeforeConsecutive, an integer representing the number of consecutive stones found. This is what is returned from this clause.
Return Value: TotalBeforeConsecutive (see parameter list).
Algorithm:  1) Extract the location that is at the provided index of sequence.
            2) If the location has a stone placed there, return the result of recursively calling this clause with one subtracted from index, + 1.
            3) Otherwise, if the location is empty or there are no more locations to check, the consecutive streak is over and 0 should be returned.
Assistance Received: None
********************************************************************* */
%Recursive case.
before_consecutive(GameState, Sequence, Index, TotalBeforeConsecutive) :-
    %Extract the location being evaluated from the sequence of locations.
    nth0(Index, Sequence, Location),
    nth0(0, Location, Row),
    nth0(1, Location, Col),
    %If the location is not empty, continue searching to the left in the sequence for more consecutive stones.
    at(GameState, Row, Col, AtLocation),
    AtLocation \= o,
    NewIndex is Index - 1,
    before_consecutive(GameState, Sequence, NewIndex, NewTotalBeforeConsecutive),
    TotalBeforeConsecutive is NewTotalBeforeConsecutive + 1.

%Base case, no more locations to check or the streak is over.
before_consecutive(_, _, _, 0).

/* *********************************************************************
Clause Name: after_consecutive
Purpose: To determine the number of consecutive stones from an index, up to the right end of a sequence. Helper clause for NumConsecutiveIfPlaced.
Parameters: GameState, a list representing the current state of the game.
            Sequence, a list representing a single sequence of locations.
            Index, an integer used to keep track of the index of the sequence that is being evaluated.
            TotalAfterConsecutive, an integer representing the number of consecutive stones found. This is what is returned from this clause.
Return Value: TotalAfterConsecutive (see parameter list).
Algorithm:  1) Extract the location that is at the provided index of sequence.
            2) If the location has a stone placed there, return the result of recursively calling this clause with one added to index, + 1.
            3) Otherwise, if the location is empty or there are no more locations to check, the consecutive streak is over and 0 should be returned.
Assistance Received: None
********************************************************************* */
%Recursive case.
after_consecutive(GameState, Sequence, Index, TotalAfterConsecutive) :-
    %Extract the location being evaluated from the sequence of locations.
    nth0(Index, Sequence, Location),
    nth0(0, Location, Row),
    nth0(1, Location, Col),
    %If the location is not empty, continue searching to the right in the sequence for more consecutive stones.
    at(GameState, Row, Col, AtLocation),
    AtLocation \= o,
    NewIndex is Index + 1,
    after_consecutive(GameState, Sequence, NewIndex, NewTotalAfterConsecutive),
    TotalAfterConsecutive is NewTotalAfterConsecutive + 1.

%Base case, no more locations to check or the streak is over.
after_consecutive(_, _, _, 0).

/* *********************************************************************
Clause Name: three_consecutive
Purpose: To find if there is a location that would result in three consecutive stones, given sequences of locations to search.
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where three consecutive stones could potentially be formed.
            DangerColor, the stone color that needs to be checked for risk of capture.
            PossiblePlay, a list representing a possible location on the board that creates three consecutive stones, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively search through each of the provided sequences of locations.
            2) For each sequence, find the empty indices within the sequence (there will either be two or three when this clause is called).
            3) Test each empty index, and if placing a stone on any of them result in three consecutive stones (calculated through num_consecutive_if_placed),
               and placing a stone there does not put the player at risk of being captured, return this location.
            4) Otherwise, continue searching the rest of the sequences through recursion.
            5) If there are no locations found after all sequences are searched, return an empty list.
Assistance Received: None
********************************************************************* */
%Base case - no three consecutive plays were found.
three_consecutive(_, [], _, []).

%Checking the first empty index in the sequence of locations.
three_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(0, EmptyIndices, FirstEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, FirstEmptyIndex, FirstTotalConsecutive),
    %If the number of consecutive stones that would occur is 3, return this location.
    FirstTotalConsecutive == 3,
    nth0(FirstEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Checking the second empty index in the sequence of locations.
three_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(1, EmptyIndices, SecondEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, SecondEmptyIndex, SecondTotalConsecutive),
    %If the number of consecutive stones that would occur is 3, return this location.
    SecondTotalConsecutive == 3,
    nth0(SecondEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Checking the third empty index in the sequence of locations. Note: May or may not exist in the sequence.
three_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(2, EmptyIndices, ThirdEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, ThirdEmptyIndex, ThirdTotalConsecutive),
    %If the number of consecutive stones that would occur is 3, return this location.
    ThirdTotalConsecutive == 3,
    nth0(ThirdEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Recursive case so that the rest of the sequences get checked.
three_consecutive(GameState, [_ | RestSequences], DangerColor, PossiblePlay) :-
    three_consecutive(GameState, RestSequences, DangerColor, PossiblePlay).

/* *********************************************************************
Clause Name: determine_build_initiative_3
Purpose: Helper clause for build_initiative to determine the optimal play when attempting to build initiative with 3 stones already placed.
Parameters: FourConsecutivePlay, a list representing a location that creates four consecutive stones on the board.
            ThreeConsecutivePlay, a list representing a location that create three consecutive stones on the board.
            A return list, representing the most optimal build initiative 3 play. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
determine_build_initiative_3([], [], []).
determine_build_initiative_3([], ThreeConsecutivePlay, ThreeConsecutivePlay).
determine_build_initiative_3(FourConsecutivePlay, _, FourConsecutivePlay).

/* *********************************************************************
Clause Name: find_middle_location_play
Purpose: To find if there is a location on the board that would result in the pattern w o * o w, used for building initiative. 
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where a possible middle location play can be built.
            DangerColor, the stone color that needs to be checked for risk of capture.
            PossiblePlay, a list representing a possible location on the board that creates the pattern w o * o w, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively search through each of the provided sequences.
            2) For each sequence, determine and store the empty indices of that sequence.
            3) If the three empty indices are 1, 2, and 3 (the sequence is w o o o w), and the middle location in the sequence does not put the player at risk of being captured, return the middle location
               in the sequence.
            4) Otherwise, recursively search the rest of the sequences.
            5) Return an empty list if no safe middle location plays are found. 
Assistance Received: None
********************************************************************* */
%Base case.
find_middle_location_play(_, [], _, []).

%Searching for the w o * o w pattern. If it's found, recursion is complete.
find_middle_location_play(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    %Extract the three empty locations in the sequence (will always be three).
    nth0(0, EmptyIndices, FirstEmptyIndex),
    nth0(1, EmptyIndices, SecondEmptyIndex),
    nth0(2, EmptyIndices, ThirdEmptyIndex),
    %When searching for the pattern w o * o w, the empty indices will be the 2nd, 3rd, and 4th location in the sequence.
    FirstEmptyIndex == 1,
    SecondEmptyIndex == 2,
    ThirdEmptyIndex == 3,
    %The return location would be the middle location of the sequence (location with index 2).
    nth0(2, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of capture.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Recursive case to search the rest of the sequences.
find_middle_location_play(GameState, [_ | RestSequences], DangerColor, PossiblePlay) :-
    find_middle_location_play(GameState, RestSequences, DangerColor, PossiblePlay).

/* *********************************************************************
Clause Name: two_consecutive
Purpose: To find if there is a location that would result in two consecutive stones, given sequences of locations to search.
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where two consecutive stones could potentially be formed.
            DangerColor, the stone color that needs to be checked for risk of capture.
            PossiblePlay, a list representing a possible location on the board that creates two consecutive stones, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively search through each of the provided sequences of locations.
            2) For each sequence, find the empty indices within the sequence (there will always be three when this clause is called).
            3) Test each empty index, and if placing a stone on any of them result in two consecutive stones (calculated through num_consecutive_if_placed),
                and placing a stone there does not put the player at risk of being captured, return this location.
            4) Otherwise, continue searching the rest of the sequences through recursion.
            5) If there are no locations found after all sequences are searched, return an empty list.
Assistance Received: None
********************************************************************* */
%Base case - no three consecutive plays were found.
two_consecutive(_, [], _, []).

%Checking the first empty index in the sequence of locations.
two_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(0, EmptyIndices, FirstEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, FirstEmptyIndex, FirstTotalConsecutive),
    %If the number of consecutive stones that would occur is 3, return this location.
    FirstTotalConsecutive == 2,
    nth0(FirstEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Checking the second empty index in the sequence of locations.
two_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(1, EmptyIndices, SecondEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, SecondEmptyIndex, SecondTotalConsecutive),
    %If the number of consecutive stones that would occur is 3, return this location.
    SecondTotalConsecutive == 2,
    nth0(SecondEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Checking the third empty index in the sequence of locations.
two_consecutive(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    nth0(2, EmptyIndices, ThirdEmptyIndex),
    num_consecutive_if_placed(GameState, Sequence, ThirdEmptyIndex, ThirdTotalConsecutive),
    %If the number of consecutive stones that would occur is 3, return this location.
    ThirdTotalConsecutive == 2,
    nth0(ThirdEmptyIndex, Sequence, ReturnLocation),
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, ReturnLocation, DangerColor),
    PossiblePlay = ReturnLocation.

%Recursive case so that the rest of the sequences get checked.
two_consecutive(GameState, [_ | RestSequences], DangerColor, PossiblePlay) :-
    two_consecutive(GameState, RestSequences, DangerColor, PossiblePlay).

/* *********************************************************************
Clause Name: determine_build_initiative_2
Purpose: Helper clause for build_initiative to determine the optimal play when attempting to build initiative with 2 stones already placed.
Parameters: ThreeConsecutivePlay, a list representing a location that create three consecutive stones on the board.
            MiddleLocationPlay, a list representing a location that forms the pattern w o w o w. 
            TwoConsecutivePlay, a list representing a location that creates two consecutive stones on the board.
            A return list, representing the most optimal build initiative 2 play. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
determine_build_initiative_2([], [], [], []).
determine_build_initiative_2([], [], TwoConsecutivePlay, TwoConsecutivePlay).
determine_build_initiative_2([], MiddleLocationPlay, _, MiddleLocationPlay).
determine_build_initiative_2(ThreeConsecutivePlay, _, _, ThreeConsecutivePlay).

/* *********************************************************************
Clause Name: find_two_locations_away
Purpose: To find a location that is a distance of two locations away from a placed stone. Main entry to the clause.
Parameters: GameState, a list representing the current state of the game.
            Color, an atom representing the player's stone color.
            DangerColor, the stone color that needs to be checked for risk of capture.
            TwoLocationsAwayPlay, a list representing a safe location that is two locations away from a placed stone. This is what is returned from this clause.
Return Value: None
Algorithm:  1) Generate all of the sequences that will potentially have a safe two locations away play.
            2) Find all possible two locations away play (see the searching version of this clause find_two_locations_away/5).
            3) Randomly choose one of the possible plays if one exists (see the determining version of this clause find_two_locations_away/2). 
Assistance Received: None
********************************************************************* */
%Main entry to the clause.
find_two_locations_away(GameState, Color, DangerColor, TwoLocationsAwayPlay) :-
    %Find the sequences that may contain a safe two locations away play.
    get_all_sequences(5, Sequences),
    search_for_sequences(GameState, Sequences, 1, 4, Color, [], SearchResult),
    
    %Call the searching version of this clause to find all possible plays.
    find_two_locations_away(GameState, Color, DangerColor, SearchResult, PossiblePlays),
    
    %Randomly select one of the safe possible plays so that the computer builds in all directions (if one exists).
    find_two_locations_away(PossiblePlays, TwoLocationsAwayPlay).

/* *********************************************************************
Clause Name: find_two_locations_away
Purpose: To find a location that is a distance of two locations away from a placed stone. This clause randomly selects one of the possible plays.
Parameters: PossiblePlays, a list containing all possible two locations away plays that do not put the player at risk of capture.
            TwoLocationsAwayPlay, a list representing the chosen two locations away play. This is what is returned from this clause.
Return Value: TwoLocationsAwayPlay (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Handles the case where there are no possible plays (prevents infinite recursion).
find_two_locations_away([], []).

%Randomly selects a location in PossiblePlays.
find_two_locations_away(PossiblePlays, TwoLocationsAwayPlay) :-
	%Randomly select one of the safe possible plays so that the computer builds in all directions.
    length(PossiblePlays, PossiblePlaysLength),
    random(0, PossiblePlaysLength, RandomIndex),
    nth0(RandomIndex, PossiblePlays, TwoLocationsAwayPlay).
    
/* *********************************************************************
Clause Name: find_two_locations_away
Purpose: To find a location that is a distance of two locations away from a placed stone. This clause deals with all of the searching.
Parameters: GameState, a list representing the current state of the game.
            Color, an atom representing the player's stone color.
            DangerColor, the stone color that needs to be checked for risk of capture.
            A list, representing potential sequences of locations that could have a valid two locations away play in them.
            A return list, representing all safe two locations away plays. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm:  1) Recursively loop through each of the sequences of locations passed to this clause.
            2) For each sequence of locations, extract the first and last locations of the sequence.
            3) If the first or last location is not empty, meaning the sequence is in the format w o o o o OR o o o o w:
                3a) If the first location is not empty (the sequence is w o o o o), add the 3rd location (middle) of the sequeunce to the return list (ex: w o * o o).
                    Recursively call this clause to search the rest of the sequences.
                3b) If the last location is not empty (the sequence is o o o o w), add the 3rd location (middle) of the sequence to the return list (ex: o o * o w).
                    Recursively call this clause to search the rest of the sequeunces.
            4) Otherwise continue searching the rest of the sequences through recursion.
            5) Once all sequences have been checked, return the list of possible two locations away plays.
Assistance Received: None
********************************************************************* */
%Base case of the searching clause.
find_two_locations_away(_, _, _, [], []).

%Searching for the pattern w o o o o OR o o o o w
find_two_locations_away(GameState, Color, DangerColor, [Sequence | RestSequences], [PossiblePlay | RestPossiblePlays]) :-
    %Extract the first (0) and last (4) locations in the sequence.
    nth0(0, Sequence, FirstLocation),
    nth0(4, Sequence, LastLocation),
    nth0(0, FirstLocation, FirstRow),
    nth0(1, FirstLocation, FirstColumn),
    nth0(0, LastLocation, LastRow),
    nth0(1, LastLocation, LastColumn),
    
    %Searching for the pattern w o o o o OR o o o o w.
    at(GameState, FirstRow, FirstColumn, AtFirstLocation),
    at(GameState, LastRow, LastColumn, AtLastLocation),
    (AtFirstLocation == Color ; AtLastLocation == Color),
    
    %If the first or last location has a desired stone on it, the possible play is in the middle of the sequence of locations. Example: w o * o o OR o o * o w.
    nth0(2, Sequence, MiddleLocation),
    
    %Make sure the location does not put the player at risk of being captured.
    no_danger_of_capture(GameState, MiddleLocation, DangerColor),
    PossiblePlay = MiddleLocation,
    
    %Recursively search the rest of the sequences.
    find_two_locations_away(GameState, Color, DangerColor, RestSequences, RestPossiblePlays).
    
%There was no two locations away play found in the current sequence, so recursively search the rest.
find_two_locations_away(GameState, Color, DangerColor, [_ | RestSequences], PossiblePlays):-
    find_two_locations_away(GameState, Color, DangerColor, RestSequences, PossiblePlays).

/* *********************************************************************
Clause Name: counter_initiative
Purpose: To find the most optimal location to counter the opponent's initiative.
Parameters: GameState, a list representing the current state of the game.
            An integer (1-3), representing the number of stones placed by the opponent player in an open five consecutive locations to search for.
            PlayerColor, an atom representing the stone color of the player calling this clause.
            Move, a list representing the most optimal counter initiative move. This is what is returned from this clause.
Return Value: Move (see parameter list).
Algorithm:  1) If the integer representing the number of stone already placed by the opponent is 3:
                1a) Call the build_initiative clause with the opponent's color to find the opponent's next best possible move when building initiative.
                1b) If a location is returned from the clause above, return this location as it is the most optimal location to block. Otherwise, an empty list is returned.
            2) If the integer representing the number of stone already placed by the opponent is 2:
            2a) Determine if it is possible to initiative a flank using the find_flanks clause. If there is a location, return it, otherwise an empty list is returned.
            3) If the integer representing the number of stone already placed by the opponent is 1:
                3a) Call the build_initiative clause with the opponent's color to find the opponent's next best possible move when building initiative.
                3b) If a location is returned from the clause above, return this location as it is the most optimal location to block. Otherwise, an empty list is returned.
Assistance Received: None
********************************************************************* */
%COUNTER INITIATIVE 3.
counter_initiative(GameState, 3, PlayerColor, Move) :-
    opponent_color(PlayerColor, OpponentColor),
    build_initiative(GameState, 3, OpponentColor, PlayerColor, Move).

%COUNTER INITIATIVE 2.
counter_initiative(GameState, 2, PlayerColor, Move) :-
    opponent_color(PlayerColor, OpponentColor),
    get_all_sequences(4, AllSequences),
    %Search for potential flanks. A flank would be in the pattern o w w o.
    search_for_sequences(GameState, AllSequences, 2, 2, OpponentColor, [], SearchResult),
    find_flanks(GameState, SearchResult, PlayerColor, Move).

%COUNTER INITIATIVE 1.
counter_initiative(GameState, 1, PlayerColor, Move) :-
    opponent_color(PlayerColor, OpponentColor),
    build_initiative(GameState, 1, OpponentColor, PlayerColor, Move).

/* *********************************************************************
Clause Name: find_flanks
Purpose: To find a location on the board that initiates a flank on the opponent, if any exist.
Parameters: GameState, a list representing the current state of the game.
            A list, representing sequences of locations where a possible flank could be initiated.
            DangerColor, the stone color that needs to be checked for risk of capture.
            PossiblePlay, a list representing a possible location on the board that initiates a flank, if one exists. This is what is returned from this clause.
Return Value: PossiblePlay (see parameter list).
Algorithm:  1) Recursively loop through each sequence of locations passed to this clause.
            2) For each sequence of locations, find and extract the empty locations.
            3) If the empty indices in the sequence of locations are 0 and 3 (the ends of the sequence of 4 locations):
                3a) A flank can be initiated. Return one of the two locations that do put the player at risk of being captured on the following turn.
                3b) If both of the locations put the player at risk of being captured, continue searching the rest of the sequeunces by recursively calling this clause.
            4) Otherwise continue recursively searching the rest of the sequeunce of locations. If all are checked, return an empty list.
Assistance Received: None
********************************************************************* */  
%Base case.
find_flanks(_, [], _, []).

%Searching for a flank in the current sequence. Checking the first empty index.
find_flanks(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    %Note: There will always be two empty indices in the sequence of locations.
    nth0(0, EmptyIndices, FirstEmptyIndex),
    nth0(1, EmptyIndices, SecondEmptyIndex),
	%Flanks are in the pattern o w w o, where the o's are where you would initiate a flank (two-turn capture).
    %To find a flank, the empty indices must be the first and last locations in the sequence.
    FirstEmptyIndex == 0,
    SecondEmptyIndex == 3,
    %Test the first empty location for no risk of capture.
    nth0(FirstEmptyIndex, Sequence, FirstLocation),
    no_danger_of_capture(GameState, FirstLocation, DangerColor),
    PossiblePlay = FirstLocation.

%Searching for a flank in the current sequence. Checking the second empty index.
find_flanks(GameState, [Sequence | _], DangerColor, PossiblePlay) :-
    find_empty_indices(GameState, Sequence, 0, EmptyIndices),
    %Note: There will always be two empty indices in the sequence of locations.
    nth0(0, EmptyIndices, FirstEmptyIndex),
    nth0(1, EmptyIndices, SecondEmptyIndex),
	%Flanks are in the pattern o w w o, where the o's are where you would initiate a flank (two-turn capture).
    %To find a flank, the empty indices must be the first and last locations in the sequence.
    FirstEmptyIndex == 0,
    SecondEmptyIndex == 3,
    %Test the second empty location for no risk of capture.
    nth0(SecondEmptyIndex, Sequence, FirstLocation),
    no_danger_of_capture(GameState, FirstLocation, DangerColor),
    PossiblePlay = FirstLocation.

%No safe flank was found, so search the rest of the sequences.
find_flanks(GameState, [_ | RestSequences], DangerColor, PossiblePlay) :-
    find_flanks(GameState, RestSequences, DangerColor, PossiblePlay).

/* *********************************************************************
Clause Name: get_random_play
Purpose: To generate a valid random location on the board. This clause is used as a fail-safe and never the most optimal play.
Parameters: GameState, a list representing the current state of the game.
            Row, an integer representing the row of a location on the board. This is what is returned from this clause.
            Column, an integer representing the column of a location on the board. This is also what is returned from this clause.
Return Value: Row and Column (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_random_play(GameState, Row, Column) :-
    random(0, 19, Row),
    random(0, 19, Column),
    at(GameState, Row, Column, Result),
    Result == o,
    true.

get_random_play(GameState, Row, Column) :-
    get_random_play(GameState, Row, Column).

/* *********************************************************************
Clause Name: determine_optimal_play
Purpose: Helper clause for optimal_play to determine the most optimal play.
Parameters: AllPotentialMoves, a list containing all possible moves in the order of their priority.
            Location, a list representing the chosen location for the most optimal location. This is what is returned from this clause.
            Reasoning, a string representing the reasoning on why the most optimal play was chosen. This is also what is returned from this clause.
Return Value: Location and Reasoning (see parameter list).
Algorithm: See optimal_play for full explanation on how the most optimal moves are chosen based on certain priorities.
Assistance Received: None
********************************************************************* */
%Attempt to make a winning move.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(0, AllPotentialMoves, WinningMove),
    WinningMove \= [],
    %Winning moves are in the form [Location, Reasoning].
    nth0(0, WinningMove, Location),
    nth0(1, WinningMove, Reasoning).
    
%Attempt to prevent a winning move.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(1, AllPotentialMoves, PreventWinningMove),
    PreventWinningMove \= [],
    %Prevent winning moves are in the form [Location, Reasoning].
    nth0(0, PreventWinningMove, Location),
    nth0(1, PreventWinningMove, Reasoning).  

%Attempt to build a deadly tessera.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(2, AllPotentialMoves, DeadlyTesseraMove),
    DeadlyTesseraMove \= [],
    Location = DeadlyTesseraMove,
    Reasoning = ' to build a deadly tessera.'.

%Attempt to prevent the opponent from building a deadly tessera.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(3, AllPotentialMoves, PreventDeadlyTesseraMove),
    PreventDeadlyTesseraMove \= [],
    Location = PreventDeadlyTesseraMove,
    Reasoning = ' to prevent the opponent from building a deadly tessera.'.

%Attempt to make a capture.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(4, AllPotentialMoves, CaptureMove),
    CaptureMove \= [],
    %Capture moves are in the form [NumCaptures, Location].
    nth0(1, CaptureMove, Location),
    Reasoning = ' to capture the opponent\'s stones.'.

%Attempt to prevent a capture.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(5, AllPotentialMoves, PreventCaptureMove),
    PreventCaptureMove \= [],
    %Prevent capture moves are in the form [NumCaptures, Location].
    nth0(1, PreventCaptureMove, Location),
    Reasoning = ' to prevent the opponent from making a capture.'.

%Attempt to build initiative with 3 stones already placed.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(6, AllPotentialMoves, BuildInitiative3Move),
    BuildInitiative3Move \= [],
    Location = BuildInitiative3Move,
    Reasoning = ' to build initiative and have four stones in an open five consecutive locations.'.
   
%Attempt to counter the opponent's initiative when they have 3 stones already placed.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(7, AllPotentialMoves, CounterInitiative3Move),
    CounterInitiative3Move \= [],
    Location = CounterInitiative3Move,
    Reasoning = ' to counter initiative and prevent the opponent from getting four stones in an open five consecutive locations.'.

%Attempt to build initiative with 2 stones already placed.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(8, AllPotentialMoves, BuildInitiative2Move),
    BuildInitiative2Move \= [],
    Location = BuildInitiative2Move,
    Reasoning = ' to build initiative and have three stones in an open five consecutive locations.'.

%Attempt to initiate a flank on the opponent.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(9, AllPotentialMoves, CounterInitiative2Move),
    CounterInitiative2Move \= [],
    Location = CounterInitiative2Move,
    Reasoning = ' to initiate a flank.'.

%Attempt to build initiative with 1 stone already placed.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(10, AllPotentialMoves, BuildInitiative1Move),
    BuildInitiative1Move \= [],
    Location = BuildInitiative1Move,
    Reasoning = ' to build initiative and have two stones in an open five consecutive locations.'.

%Attempt to counter the opponent's initiative when they have 1 stone already placed.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(11, AllPotentialMoves, CounterInitiative1Move),
    CounterInitiative1Move \= [],
    Location = CounterInitiative1Move,
    Reasoning = ' to counter the opponent\'s initiative and begin building initiative.'.

%Fail-safe that should never happen, just in case the strategies above are invalid.
determine_optimal_play(AllPotentialMoves, Location, Reasoning) :-
    nth0(12, AllPotentialMoves, RandomPlay),
    RandomPlay \= [],
    Location = RandomPlay,
    Reasoning = ' because there are no other optimal plays.'.

/* *********************************************************************
Clause Name: convert_num_to_character
Purpose: To convert a number (representing a column) into its character representation. 
Parameters: NumToConvert, an integer representing the number to be converted.
            ConvertedNum, an atom representing the character representation of the number passed (Ex: 0 --> A). This is what is returned from this clause.
Return Value: ConvertedNum (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
convert_num_to_character(NumToConvert, ConvertedNum) :-
    ASCII is NumToConvert + 65,
    char_code(ConvertedNum, ASCII).

/* *********************************************************************
Clause Name: determine_round_over
Purpose: To determine if a round of Pente is complete.
Parameters: GameState, a list representing the current state of the game.
            CompletedState, a list representing the completed round game state (if the round is over). This is what is returned from this clause.
            An integer, representing the number of stones placed on the board.
            WhiteStonesWin, a list representing a sequence of locations that potentially has five consecutive white stones on it.
            BlackStonesWin, a list representing a sequence of locations that potentially has five consecutive black stones on it.
Return Value: CompletedState (see parameter list).
Algorithm:  1) If the board has 361 stones placed on it (19 x 19) the board is completely full and the round is over.
            2) Next, check if either the human player or computer player have achieved five captured pairs. If they have, the round is over.
            3) Finally, check if either players have achieved five consecutive stones. If they have, the round is over.
            4) Otherwise, the round is not over and the next player should take their turn (achieved via calling the start_round clause).
Assistance Received: None
********************************************************************* */
%The board is completely full.
determine_round_over(GameState, CompletedState, 361, _, _) :-
    CompletedState = GameState,
    write('ROUND OVER! The round has ended because the board is completely full'), nl, nl.

%The human player has at least five captured pairs.
determine_round_over(GameState, CompletedState, _, _, _) :-
    get_human_captured(GameState, HumanCaptured),
    HumanCaptured >= 5,
    CompletedState = GameState,
    write('ROUND OVER! The round has ended because the Human player has at least five captured pairs.'), nl, nl.

%The computer player has at least five captured pairs.
determine_round_over(GameState, CompletedState, _, _, _) :-
    get_computer_captured(GameState, ComputerCaptured),
    ComputerCaptured >= 5,
    CompletedState = GameState,
    write('ROUND OVER! The round has ended because the Computer player has at least five captured pairs.'), nl, nl.

%The human player has at least five consecutive stones and is playing white stones.
determine_round_over(GameState, CompletedState, _, WhiteStonesWin, _) :-
    length(WhiteStonesWin, WinLength),
    WinLength > 0,
    CompletedState = GameState,
    get_next_player(GameState, NextPlayer),
    NextPlayer == computer,
    write('ROUND OVER! The round has ended because the Human player has achieved five or more consecutive stones.'), nl, nl.

%The computer player has at least five consecutive stones and is playing white stones.
determine_round_over(GameState, CompletedState, _, WhiteStonesWin, _) :-
    length(WhiteStonesWin, WinLength),
    WinLength > 0,
    CompletedState = GameState,
    write('ROUND OVER! The round has ended because the Computer player has achieved five or more consecutive stones.'), nl, nl.

%The human player has at least five consecutive stones and is playing black stones.
determine_round_over(GameState, CompletedState, _, _, BlackStonesWin) :-
    length(BlackStonesWin, WinLength),
    WinLength > 0,
    CompletedState = GameState,
    get_next_player(GameState, NextPlayer),
    NextPlayer == computer,
    write('ROUND OVER! The round has ended because the Human player has achieved five or more consecutive stones.'), nl, nl.

%The computer player has at least five consecutive stones and is playing black stones.
determine_round_over(GameState, CompletedState, _, _, BlackStonesWin) :-
    length(BlackStonesWin, WinLength),
    WinLength > 0,
    CompletedState = GameState,
    write('ROUND OVER! The round has ended because the Computer player has achieved five or more consecutive stones.'), nl, nl.

%The round isn't over, continue playing the round.
determine_round_over(GameState, CompletedState, _, _, _) :-
    start_round(GameState, CompletedState, play).

/* *********************************************************************
Clause Name: update_scores
Purpose: To update and display both the Human and Computer players' tournament score after a round is completed.
Parameters: GameState, a list representing the current state of the game.
            ScoresUpdatedGameState, a list representing the game set list with both the human and computer players' tournament score correctly updated. This is what is returned from this clause.
Return Value: ScoresUpdatedGameState (see parameter list).
Algorithm:  1) Obtain the scores earned by each player for the round (see score_board). 
            2) Display the scores earned by each player for the current round.
            3) Update the Human's tournament score.
            4) Update the Computer's tournament score.
            5) Display the updated tournament scores to the screen and return the updated game state.
Assistance Received: None
********************************************************************* */
update_scores(GameState, ScoresUpdatedGameState) :-
    %First, get each player's information from the game state list.
    get_human_color(GameState, HumanColor),
    get_human_captured(GameState, HumanCaptured),
    get_human_score(GameState, HumanCurrentScore),
    get_computer_color(GameState, ComputerColor),
    get_computer_captured(GameState, ComputerCaptured),
    get_computer_score(GameState, ComputerCurrentScore),

    %Calculate the scores earned by each player.
    score_board(GameState, HumanColor, HumanCaptured, HumanScoreEarned),
    score_board(GameState, ComputerColor, ComputerCaptured, ComputerScoreEarned),

    %Display the round scores to the user.
    write('========================================================================================='), nl,
    write('Points earned by the Human player this round: '),
    write(HumanScoreEarned), nl,
    write('Points scored by the Computer player this round: '),
    write(ComputerScoreEarned), nl, nl,

    %Set the scores, and return the updated game state.
    UpdatedHumanScore is HumanCurrentScore + HumanScoreEarned,
    UpdatedComputerScore is ComputerCurrentScore + ComputerScoreEarned,
    set_human_score(GameState, UpdatedHumanScore, HumanScoreState),
    set_computer_score(HumanScoreState, UpdatedComputerScore, ScoresUpdatedGameState),

    %Display the updated tournament scores to the user.
    write('The updated Human player\'s tournament score is: '),
    write(UpdatedHumanScore), nl,
    write('The updated Computer player\'s tournament score is: '),
    write(UpdatedComputerScore), nl,
    write('========================================================================================='), nl, nl.

/* *********************************************************************
Clause Name: score_board
Purpose: To score the board for a given stone color.
Parameters: GameState, a list representing the current state of the game.
            Color, an atom representing the player's stone color.
            CapturedPairCount, an integer representing the number of captured pairs the player has.
            TotalScoreEarned, an integer representing the total score the player has earned for the round. This is what is returned     
Return Value: TotalScoreEarned (see parameter list).
Algorithm:  1) First, tally up all the points earned from five (or more) consecutive stones on the board (see score_five_consecutives). Call this clause for all four of
               the major directions (horizontal, vertical, main-diagonal, anti-diagonal). 
            2) Extract the score earned, as well as the marked board (so that consecutive fives do not get recounted as conscecutive fours), from the returned values
               in Step 1.
            3) Next, tally up all the points earned from four consecutive stones on the board. The marked board from step 2 is used so that consecutive fives
               do not accidently get recounted.
            4) Last, sum up all of the scores earned from consecutive fives and consecutive fours with the number of captured pairs that player has. Return this sum
               as the scored earned by that player for the round.
Assistance Received: None
********************************************************************* */
score_board(GameState, Color, CapturedPairCount, TotalScoreEarned) :-
    %Setup for the calculations.
    all_board_locations(0, 0, Locations),
    %The sequences below are all valid sequences in each major directions that are of length 4 (for scoring four consecutives).
    get_sequences_in_direction(Locations, 0, 1, 4, SequencesH),
    get_sequences_in_direction(Locations, 1, 0, 4, SequencesV),
    get_sequences_in_direction(Locations, 1, 1, 4, SequencesMD),
    get_sequences_in_direction(Locations, 1, -1, 4, SequencesAD),
    filter_sequences(SequencesH, FilteredSequencesH),
    filter_sequences(SequencesV, FilteredSequencesV),
    filter_sequences(SequencesMD, FilteredSequencesMD),
    filter_sequences(SequencesAD, FilteredSequencesAD),
    
    %First, obtain the scores in each major direction from five consecutive stones or more.
    %The four major directions are horizontal, vertical, main-diagonal, and anti-diagonal.
    score_five_consecutives(GameState, Locations, Color, 0, 1, MarkedBoardStateH, FiveConsecutiveScoreH),
    score_five_consecutives(GameState, Locations, Color, 1, 0, MarkedBoardStateV, FiveConsecutiveScoreV),
    score_five_consecutives(GameState, Locations, Color, 1, 1, MarkedBoardStateMD, FiveConsecutiveScoreMD),
    score_five_consecutives(GameState, Locations, Color, 1, -1, MarkedBoardStateAD, FiveConsecutiveScoreAD),
    FiveConsecutiveScoreTotal is FiveConsecutiveScoreH + FiveConsecutiveScoreV + FiveConsecutiveScoreMD + FiveConsecutiveScoreAD,
    
    %Next obtain the scores in each major direction from four consecutive stones.
    %The boards being used will be marked so that consecutive five or more stones in a row do not get recounted.
    score_four_consecutives(MarkedBoardStateH, FilteredSequencesH, Color, FourConsecutiveScoreH),
    score_four_consecutives(MarkedBoardStateV, FilteredSequencesV, Color, FourConsecutiveScoreV),
    score_four_consecutives(MarkedBoardStateMD, FilteredSequencesMD, Color, FourConsecutiveScoreMD),
	score_four_consecutives(MarkedBoardStateAD, FilteredSequencesAD, Color, FourConsecutiveScoreAD),
    FourConsecutiveScoreTotal is FourConsecutiveScoreH + FourConsecutiveScoreV + FourConsecutiveScoreMD + FourConsecutiveScoreAD,
    
    %Return the score earned from the board, plus the number of captured pairs the player has.
    TotalScoreEarned is FiveConsecutiveScoreTotal + FourConsecutiveScoreTotal + CapturedPairCount.

/* *********************************************************************
Clause Name: score_five_consecutives
Purpose: To return the score earned from five consecutive stones in a specific direction, as well as the marked board (used for later processing).
Parameters: GameState, a list representing the current state of the game.
            A list, representing all valid board locations on the board.
            Color, an atom representing the player's stone color.
            RowChange, an integer representing the directional change applied to each row.
            ColChange, an integer representing the directional change applied to each column.
            MarkedBoardState, a list representing a game state list with five or more consecutive stones marked on the board. This is what is returned from this clause.
            ScoreEarned, an integer representing the total score earned via five or more consecutive stones. This is also what is returned from this clause.
Return Value: MarkedBoardState and ScoreEarned (see parameter list).
Algorithm:  1) Recursively loop through each of the valid board locations.
            2) For each board locations, find the maximum consecutive stone streak in the provided direction (RowChange, ColChange).
            3) If the maximum consecutive stone streak is greater than or equal to 5, mark the consecutive streak as seen (so that it never gets recounted),
               and recursively call this clause with the marked board game state and the score incremented by 5.
            4) Otherwise, continue searching the rest of the board locations.
            5) Once all board locations have been searched, return a game state list with the marked board and the score earned from five consecutive stones in
               the specific direction provided to this clause.
Assistance Received: None
********************************************************************* */
%Base case.
score_five_consecutives(GameState, [], _, _, _, MarkedBoardState, 0) :-
    %Return the fully marked board game state. This will be used to score four consecutives.
    MarkedBoardState = GameState.

%Recursive case - a streak of 5 or more was found at the location.
score_five_consecutives(GameState, [Location | RestLocations], Color, RowChange, ColChange, MarkedBoardState, ScoreEarned) :-
    max_consecutive_stones(GameState, Location, Color, RowChange, ColChange, LongestStreak),
    length(LongestStreak, LongestStreakLength),
    
    %Winning moves can have 5 or more consecutive stones.
    LongestStreakLength >= 5,
    
    %Mark the board so that other winning moves do not get recounted.
    get_board(GameState, CurrentBoard),
    mark_board(CurrentBoard, LongestStreak, MarkedBoard),
    set_board(GameState, MarkedBoard, MarkedBoardGameState),
    
    %Increment the score earned by 5 by recursively searching through the rest of the board.
    score_five_consecutives(MarkedBoardGameState, RestLocations, Color, RowChange, ColChange, MarkedBoardState, RestScoreEarned),
    ScoreEarned is RestScoreEarned + 5.

%Recursive case, a streak of 5 was NOT found at the location being evaluated.
score_five_consecutives(GameState, [_ | RestLocations], Color, RowChange, ColChange, MarkedBoardState, ScoreEarned) :-
    score_five_consecutives(GameState, RestLocations, Color, RowChange, ColChange, MarkedBoardState, ScoreEarned).

/* *********************************************************************
Clause Name: max_consecutive_stones
Purpose: To find the maximum number of consecutive stones starting from a provided location going in a specific direction.
Parameters: GameState, a list representing the current state of the game.
            A list, in the format [Row, Col], representing a location on the board.
            Color, an atom representing the player's stone color.
            RowChange, an integer representing the directional change applied to each row.
            ColChange, an integer representing the directional change applied to each column.
            A return list, representing all of the consecutive locations on the board that have the desired stone placed on them. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm:  1) Make sure the location being evaluated is valid in terms of board constraints.
            2) Check if the stone placed at the location (if there is one) is of the desired color.
            3) If there is a stone of the color being searched for at this location, add the location to the return list.
                3a) Generate the next location in the consecutive streak to be checked, and recursively call this location with the generated location.
            4) Once a location generated is not valid, OR the consecutive streak ends, return the list containing the sequence of locations.
Assistance Received: None
********************************************************************* */
%Recursive case - continue searching locations until the streak ends.
max_consecutive_stones(GameState, [Row, Col], Color, RowChange, ColChange, [Location | RestLocations]) :-
    %Note: the location must be valid for the streak to continue.
    valid_indices(Row, Col),
    
    %Determine if the stone at the location is the one being searched for.
    at(GameState, Row, Col, AtLocation),
    AtLocation == Color,
    Location = [Row, Col],
    
    %Generate the next location to check in the streak and search it.
    NewRow is Row + RowChange,
    NewCol is Col + ColChange,
    NewLocation = [NewRow, NewCol],
    max_consecutive_stones(GameState, NewLocation, Color, RowChange, ColChange, RestLocations).

%Base case - the streak is over.
max_consecutive_stones(_, _, _, _, _, []).

/* *********************************************************************
Clause Name: mark_board
Purpose: To mark locations on a provided board with "s" to represent seen. Helper clause used when scoring a board.
Parameters: Board, a list representing the current board of the game.
            A list, representing the locations on the board that need to be marked.
            MarkedBoard, a list, representing the fully marked board. This is what is returned from this clause.
Return Value: MarkedBoard (see parameter list).
Algorithm:  1) Recursively loop through each of the board locations that need to be marked.
            2) Update the location with an "s" to represent it as seen.
            3) Once all locations have been marked, return the marked board.
Assistance Received: None
********************************************************************* */
%Base case.
mark_board(Board, [], MarkedBoard) :-
    MarkedBoard = Board.

%Recursive case.
mark_board(Board, [[Row, Col] | RestLocations], MarkedBoard) :-
    update_board(Board, Row, Col, s, NewBoard),
    mark_board(NewBoard, RestLocations, MarkedBoard).

/* *********************************************************************
Clause Name: score_four_consecutives
Purpose: To return the score earned from four consecutive stones in a specific direction.
Parameters: GameState, a list representing the current state of the game.
            A list, representing all sequences of four locations that needs to be checked.
            Color, an atom representing the player's stone color.
            ScoreEarned, an integer representing the total score earned via four consecutive stones. This is what is returned from this clause.
Return Value: ScoreEarned (see parameter list).
Algorithm:  1) Recursively loop through each of the sequences that need to be searched.
            2) For each sequence, check if the number of stones placed in that sequence of locations is equal to four (see stone_count_in_sequence).
            3) If it is equal to four, recursively call this clause with ScoreEarned incremented by 1 to search the rest of the sequences.
            4) Otherwise, continue searching the rest of the sequences. Once all sequences have been checked, return the resulting score.
Assistance Received: None
********************************************************************* */
%Base case.
score_four_consecutives(_, [], _, 0).

%Recursive case - four consecutive stones as found.
score_four_consecutives(GameState, [Sequence | RestSequences], Color, ScoreEarned) :-
	stone_count_in_sequence(GameState, Sequence, Color, StonesPlaced),
    
    %There is four consecutive stones found in the sequence.
    StonesPlaced == 4,
    
    %Increment the score earned by 1 by recursively searching through the rest of the sequences.
    score_four_consecutives(GameState, RestSequences, Color, RestScoreEarned),
    ScoreEarned is RestScoreEarned + 1.

%Recursive case - four consecutive stones were not found.
score_four_consecutives(GameState, [_ | RestSequences], Color, ScoreEarned) :-
    score_four_consecutives(GameState, RestSequences, Color, ScoreEarned).

/* *********************************************************************
Clause Name: set_human_score
Purpose: To set the human score into the game state.
Parameters: GameState, a list representing the current state of the game.
            NewHumanScore, an integer representing the new human score to set.
            A return list, representing the updated game state list with the new human score set. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Validate the new human score.
set_human_score([First, Second, _ | RestOldState], NewHumanScore, [First, Second, NewHumanScore | RestOldState]) :-
    NewHumanScore >= 0.

set_human_score(GameState, _, GameState) :-
    write('Invalid human score!'), nl.

/* *********************************************************************
Clause Name: set_computer_score
Purpose: To set the computer score into the game state.
Parameters: GameState, a list representing the current state of the game.
            NewComputerScore, an integer representing the new computer score to set.
            A return list, representing the updated game state list with the new computer score set. This is what is returned from this clause.
Return Value: (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%Validate the new computer score.
set_computer_score([First, Second, Third, Fourth, _ | RestOldState], NewComputerScore, [First, Second, Third, Fourth, NewComputerScore | RestOldState]) :-
    NewComputerScore >= 0.

set_computer_score(GameState, _, GameState) :-
    write('Invalid computer score!'), nl.

/* *********************************************************************
Clause Name: reset_round
Purpose: To reset the game state to be ready to play another round of Pente, if the user chooses to do so.
Parameters: GameState, a list representing the current state of the game.
            ResetState, a list representing the game state list with the round reset, ready to play another around. This is what is returned from this clause.
Return Value: ResetState (see parameter list).
Algorithm:  1) Extract the human and computer's tournament scores from the original game state list.
            2) Create a new game state list.
            3) Set the old tournament scores into the new game state list, and return this game state list.
Assistance Received: None
********************************************************************* */
reset_round(GameState, ResetState) :-
    %Extract the tournament scores of each player.
    get_human_score(GameState, HumanScore),
    get_computer_score(GameState, ComputerScore),

    %Make a new game list, and set the tournament scores of each player.
    new_game_list(NewGameState),
    set_human_score(NewGameState, HumanScore, HumanScoreState),
    set_computer_score(HumanScoreState, ComputerScore, ResetState).

/* *********************************************************************
Clause Name: get_continue_decision
Purpose: To ask the user whether or not the user would like to play another round of Pente.
Parameters: Choice, an atom the user's choice. This is what is returned from the clause.
Return Value: Choice (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
get_continue_decision(Choice) :-
    write('Would you like to continue playing and start a new round? Enter y or n: '),
    read(Input),
    validate_continue_decision(Input, Choice).

/* *********************************************************************
Clause Name: validate_continue_decision
Purpose: To validate the user's continue decision.
Parameters: Input, an atom representing the user's choice.
            ValidatedInput, an atom representing input that has been validated. This is what is returned from the clause.
Return Value: ValidatedInput (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
validate_continue_decision(Input, ValidatedInput) :-
    (Input == y ; Input == n),
    ValidatedInput = Input.

validate_continue_decision(_, ValidatedInput) :-
    write('Invalid continue decision! Please re-enter (y or n): '),
    read(NewInput),
    validate_continue_decision(NewInput, ValidatedInput).

/* *********************************************************************
Clause Name: continue_tournament
Purpose: To either continue the pente tournament or end the tournament based on the user's choice.
Parameters: An atom (y or n), representing the user's choice on continuing the tournament or not.
            ResetRoundGameState, a list representing the game state list of the reset round, ready to be played again. This is what is returned from this clause (if the user chooses to keep playing).
Return Value: ResetRoundGameState (see parameter list).
Algorithm: None
Assistance Received: None
********************************************************************* */
%The user wishes to play another round and continue the tournament.
continue_tournament(y, ResetRoundGameState) :-
    start_tournament(ResetRoundGameState).

%The user wants to end the tournament.
continue_tournament(n, ResetRoundGameState) :-
    get_human_score(ResetRoundGameState, HumanScore),
    get_computer_score(ResetRoundGameState, ComputerScore),
    display_winner(HumanScore, ComputerScore).

/* *********************************************************************
Clause Name: display_winner
Purpose: To determine and display the winner of the tournament.
Parameters: HumanScore, an integer representing the score the human earned during the tournament.
            ComputerScore, an integer representing the score the computer earned during the tournament.
Return Value: None
Algorithm:  1) If the human has more points, the human has won the tournament.
            2) If the computer has more points, the computer has won the tournament.
            3) Otherwise, the tournament has ended in a draw.
Assistance Received: None
********************************************************************* */
%The human won the tournament.
display_winner(HumanScore, ComputerScore) :-
    HumanScore > ComputerScore, nl,
    write('The winner of the tournament is the Human player by a score of '),
    write(HumanScore),
    write(' to '),
    write(ComputerScore),
    write('.').

%The comptuer won the tournament.
display_winner(HumanScore, ComputerScore) :-
    ComputerScore > HumanScore, nl,
    write('The winner of the tournament is the Computer player by a score of '),
    write(ComputerScore),
    write(' to '),
    write(HumanScore),
    write('.').

%The tournament ended in a draw.
display_winner(_, _) :-
    nl,
    write('The tournament has ended in a draw since the scores are tied.').
    
