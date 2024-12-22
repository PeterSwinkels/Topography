DEFINT A-Z
OPTION BASE 0

DECLARE FUNCTION AnswerIsCorrect (CityName() AS STRING, CityX() AS INTEGER, CityY() AS INTEGER, City AS INTEGER, CursorX AS INTEGER, CursorY AS INTEGER)
DECLARE FUNCTION Choose$ (x AS INTEGER, y AS INTEGER, Prompt AS STRING, Choices AS STRING)
DECLARE FUNCTION NextCity (CityName() AS STRING)
DECLARE SUB AskCity (CityName() AS STRING, City AS INTEGER)
DECLARE SUB CheckAnswer (City AS INTEGER, CursorX AS INTEGER, CursorY AS INTEGER)
DECLARE SUB DisplayCities (CityName() AS STRING, CityX() AS INTEGER, CityY() AS INTEGER)
DECLARE SUB DisplayImage (ImageFile AS STRING, ImageX AS INTEGER, ImageY AS INTEGER)
DECLARE SUB DisplayTitle ()
DECLARE SUB Initialize ()
DECLARE SUB LoadCities (CityName() AS STRING, CityX() AS INTEGER, CityY() AS INTEGER)
DECLARE SUB LoadMap ()
DECLARE SUB Quit ()
DECLARE SUB Main ()

Initialize
DisplayTitle

CALL Main

FUNCTION AnswerIsCorrect (CityName() AS STRING, CityX() AS INTEGER, CityY() AS INTEGER, City AS INTEGER, CursorX AS INTEGER, CursorY AS INTEGER)
DIM Background(0 TO 45) AS INTEGER
DIM Correct AS INTEGER

 IF CursorX >= CityX(City) - 10 AND CursorX <= CityX(City) + 10 AND CursorY >= CityY(City) - 10 AND CursorY <= CityY(City) + 10 THEN
  Correct = -1
 ELSE
  Correct = 0

  SOUND 37, 3
  LOCATE 27, 1
  PRINT SPACE$(80);
  GET (CityX(City) + 24, CityY(City) + 6)-STEP(10, 10), Background
  DRAW "BM" + STR$(CityX(City) + 25) + "," + STR$(CityY(City) + 10) + "C15 D5 R5 H2 E5 H1 G5 H2 TA20 BD2 P15,15 TA0 D2 E6"
  COLOR 15
  LOCATE 27, 11
  PRINT CityName(City); " is located here.";
  DO WHILE INKEY$ = "": LOOP
  PUT (CityX(City) + 24, CityY(City) + 6), Background, PSET
  LOCATE 27, 1
  PRINT SPACE$(80);
 END IF

 AnswerIsCorrect = Correct
END FUNCTION

SUB AskCity (CityName() AS STRING, City AS INTEGER)
 COLOR 15
 LOCATE 27, 11
 PRINT "Point out where "; CityName(City); " is."; SPACE$(15);
END SUB

FUNCTION Choose$ (x AS INTEGER, y AS INTEGER, Prompt AS STRING, Choices AS STRING)
DIM Choice AS STRING

 LOCATE x, y
 PRINT Prompt;

 DO
  Choice = UCASE$(INPUT$(1))
 LOOP UNTIL INSTR(Choices, Choice) > 0

 LOCATE x, y
 PRINT SPACE$(LEN(Prompt));

 Choose$ = Choice
END FUNCTION

SUB DisplayCities (CityName() AS STRING, CityX() AS INTEGER, CityY() AS INTEGER)
DIM City AS INTEGER

 FOR City = LBOUND(CityName) TO UBOUND(CityName)
  CIRCLE (CityX(City) + 20, CityY(City) + 20), 3, 4
  PAINT (CityX(City) + 20, CityY(City) + 20), 4, 4
 NEXT City
END SUB

SUB DisplayImage (ImageFile AS STRING, ImageX AS INTEGER, ImageY AS INTEGER)
DIM Image(0 TO 25999) AS INTEGER
 
 DEF SEG = VARSEG(Image(0))
 BLOAD ImageFile, VARPTR(Image(0))
 PUT (ImageX, ImageY), Image, PSET
END SUB

SUB DisplayTitle
DIM FileH AS INTEGER
DIM Row AS STRING

 COLOR 15
 FileH = FREEFILE
 OPEN "Title.dat" FOR INPUT LOCK READ WRITE AS FileH
  DO UNTIL EOF(FileH)
   LINE INPUT #FileH, Row
   PRINT Row;
  LOOP
 CLOSE FileH

 DisplayImage "Title.img", 100, 100

 COLOR 7
 LOCATE 9, 27: PRINT "   Topography v1.10"
 LOCATE , 27: PRINT "  By: Peter Swinkels"
 LOCATE , 27: PRINT "      ***1997***"
 LOCATE 25, 5: PRINT "Press a key to continue..."

 DO
 LOOP WHILE INKEY$ = ""

 CLS
END SUB

SUB Initialize
 RANDOMIZE TIMER
 SCREEN 12
 WIDTH 80, 30
 COLOR 15
 CLS
END SUB

SUB LoadCities (CityName() AS STRING, CityX() AS INTEGER, CityY() AS INTEGER)
DIM City AS INTEGER
DIM FileH AS INTEGER

 FileH = FREEFILE
 OPEN "Cities.dat" FOR INPUT AS FileH
  FOR City = LBOUND(CityName) TO UBOUND(CityName)
   INPUT #FileH, CityName(City), CityX(City), CityY(City)
  NEXT City
 CLOSE FileH
END SUB

SUB Main
DIM Background(0 TO 45)
DIM City AS INTEGER
DIM CityName(0 TO 24) AS STRING
DIM CityX(0 TO 24) AS INTEGER
DIM CityY(0 TO 24) AS INTEGER
DIM CursorX AS INTEGER
DIM CursorY AS INTEGER
DIM KeyStroke AS STRING
DIM Right AS INTEGER
DIM Turn AS INTEGER
DIM Wrong AS INTEGER

 LoadCities CityName(), CityX(), CityY()
 DisplayImage "Nthrlnd.img", 20, 20
 DisplayCities CityName(), CityX(), CityY()
 
 City = NextCity(CityName())
 CursorX = 146
 CursorY = 170
 Right = 0
 Turn = 1
 Wrong = 0

 DO
  COLOR 7
  LOCATE 1, 5
  PRINT USING "Turn: ###  Wrong: ###  Right: ### "; Turn; Wrong; Right;
  GET (CursorX + 10, CursorY + 10)-STEP(10, 10), Background
  DRAW "BM" + STR$(CursorX + 15) + "," + STR$(CursorY + 15) + "C15 D5 BH5 R10 BH5 D5"
  DO
   KeyStroke = INKEY$
  LOOP WHILE KeyStroke = ""
  PUT (CursorX + 10, CursorY + 10), Background, PSET
  SELECT CASE KeyStroke
   CASE CHR$(0) + "H"
    IF CursorY > 10 THEN CursorY = CursorY - 2
   CASE CHR$(0) + "P"
    IF CursorY < 350 THEN CursorY = CursorY + 2
   CASE CHR$(0) + "K"
    IF CursorX > 10 THEN CursorX = CursorX - 2
   CASE CHR$(0) + "M"
    IF CursorX < 282 THEN CursorX = CursorX + 2
   CASE CHR$(13)
    IF AnswerIsCorrect(CityName(), CityX(), CityY(), City, CursorX, CursorY) THEN
     Right = Right + 1
    ELSE
     Wrong = Wrong + 1
    END IF

    IF Turn = 25 THEN
     SELECT CASE Choose(27, 6, "Do you want to try again y/n?" + SPACE$(15), "YN")
      CASE "N"
       Quit
      CASE "Y"
       City = NextCity(CityName())
       CursorX = 146
       CursorY = 170
       Right = 0
       Turn = 1
       Wrong = 0
     END SELECT
    ELSE
     Turn = Turn + 1
     City = NextCity(CityName())
    END IF
   CASE CHR$(27)
    COLOR 15
    IF Choose(27, 6, "Do you want to quit y/n?" + SPACE$(15), "YN") = "Y" THEN
     Quit
    ELSE
     AskCity CityName(), City
    END IF
  END SELECT
 LOOP
END SUB

FUNCTION NextCity (CityName() AS STRING)
DIM City AS INTEGER

 City = INT(RND * UBOUND(CityName)) + 1
 AskCity CityName(), City
 LINE (0, 16)-(639, 16), 15

 NextCity = City
END FUNCTION

SUB Quit
 SCREEN 0
 WIDTH 80, 25
 COLOR 7, 0
 CLS
 SYSTEM
END SUB

