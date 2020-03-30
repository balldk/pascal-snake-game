{DECLARE}
program pascal_snake_game;
uses crt;
type Vector = record x,y:byte; end;
const
    GAME_COLOR = LightCyan;
    DEFAULT_SPEED = 8;
    SNAKE_HEAD = '@';
    SNAKE_BODY = '0';
    FOOD_SHAPE = 'X';
var
    food: Vector;
    snake: array[1..1000] of Vector;
    moveX, moveY, len, speed, score: integer;
    key: char;
    isDie: boolean;
{DRAW SNAKE}
procedure drawSnake;
var i: integer;
begin
    gotoXY(snake[len].x, snake[len].y);
    write(SNAKE_HEAD);
    for i := 1 to len-1 do begin
        gotoXY(snake[i].x, snake[i].y);
        write(SNAKE_BODY);
    end;
end;
{DRAW FOOD}
procedure drawFood;
begin
    gotoXY(food.x, food.y);
    write(FOOD_SHAPE);
end;
{DRAW SCOREBOARD}
procedure drawScoreboard;
begin
    gotoXY(65, 2);
    writeln('Score: ', score, ' | Speed: ', speed);

    gotoXY(1, 1); write('#');
    gotoXY(60, 1); write('#');
    gotoXY(1, 25); write('#');
    gotoXY(60, 25); write('#');
end;
{UPDATE}
procedure update;
var i: integer;
begin
    for i := 1 to len-1 do snake[i] := snake[i+1];
    snake[len].x := snake[len].x + moveX;
    snake[len].y := snake[len].y + moveY;

    if (snake[len].x = 0) then snake[len].x := 60
    else if (snake[len].x = 61) then snake[len].x := 1;

    if (snake[len].y = 0) then snake[len].y := 25
    else if (snake[len].y = 26) then snake[len].y := 1;
end;
{GROW}
procedure grow;
begin
    snake[len+1].x := snake[len].x + moveX;
    snake[len+1].y := snake[len].y + moveY;
    inc(len);
end;
{RANDOM FOOD}
procedure randomFood;
begin
    randomize;
    food.x := random(19) + 1;
    food.y := random(19) + 1;
end;
{CHECK EAT}
procedure checkEat;
begin
    if (snake[len].x = food.x) and (snake[len].y = food.y) then begin
        randomFood;
        grow;
        inc(score);
    end;
end;
{CHECK DIE}
procedure checkDie;
var i: integer;
begin
    for i := 1 to len-1 do begin
        if (snake[i].x = snake[len].x) and (snake[i].y = snake[len].y) then isDie := true;
    end;
end;
{START SCREEN}
procedure startScreen;
begin
    writeln;
    writeln('  #=======================================#');
    writeln('  |                                       |');
    writeln('  |     WELCOME TO CONSOLE SNAKE GAME     |');
    writeln('  |                                       |');
    writeln('  #=======================================#');
    writeln('  |                                       |');
    writeln('  |     [ARROW KEYS]   -   Move snake     |');
    writeln('  |                                       |');
    writeln('  |     [1]            -   Speed down     |');
    writeln('  |                                       |');
    writeln('  |     [2]            -   Speed up       |');
    writeln('  |                                       |');
    writeln('  |     [p]            -   Pause          |');
    writeln('  |                                       |');
    writeln('  |     [r]            -   Restart        |');
    writeln('  |                                       |');
    writeln('  |     [ESC]          -   Quit           |');
    writeln('  |                                       |');
    writeln('  #=======================================#');
    writeln; writeln;
    write('* Press any key to play...');
    key := readkey;
end;
{INITIALIZE GAME}
procedure initGame;
begin
    clrscr;
    textcolor(GAME_COLOR);

    len := 1;
    snake[1].x := 5;
    snake[1].y := 5;
    randomFood;

    score := 0;
    speed := DEFAULT_SPEED;
    moveX := 1;
    moveY := 0;
    isDie := false;

    startScreen;
end;
{MAIN}
begin
    initGame;
    while (key <> #27) do begin {ESCAPE}
        if (isDie = true) then begin
            clrscr;
            gotoXY(30, 10);
            write('GAME OVER!');
            gotoXY(30, 12);
            write('Score: ', score);
            readkey;
            initGame;
        end;
        while (not keypressed()) do begin
            update;

            checkEat;
            checkDie;
            if (isDie = true) then break;

            clrscr;
            drawSnake;
            drawFood;
            drawScoreboard;

            delay((11 - speed) * 50);
        end;
        if (isDie = true) then continue;
        key := readkey;
        if (key = #72) and ((moveX <> 0) or (moveY <> 1)) then begin {UP}
            moveX := 0;
            moveY := -1;
        end else if (key = #80) and ((moveX <> 0) or (moveY <> -1)) then begin {DOWN}
            moveX := 0;
            moveY := 1;
        end else if (key = #75) and ((moveX <> 1) or (moveY <> 0)) then begin {LEFT}
            moveX := -1;
            moveY := 0;
        end else if (key = #77) and ((moveX <> -1) or (moveY <> 0)) then begin {RIGHT}
            moveX := 1;
            moveY := 0;
        end else if (key = #49) then begin {1 - speed down}
            if (speed > 1) then dec(speed);
        end else if (key = #50) then begin {2 - speed up}
            if (speed < 10) then inc(speed);
        end else if (key = #114) then begin {r - restart}
            initGame;
        end else if (key = #112) then begin {p - pause}
            key := readkey;
        end else if (key = #27) then begin {esc - exit}
            exit;
        end;
    end;
end.