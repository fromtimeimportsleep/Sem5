import Data.List

board1 =
  [ ['2', '.', '.', '.', '.', '1', '.', '3', '8'],
    ['.', '.', '.', '.', '.', '.', '.', '.', '5'],
    ['.', '7', '.', '.', '.', '6', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '.', '.', '1', '3'],
    ['.', '9', '8', '1', '.', '.', '2', '5', '7'],
    ['3', '1', '.', '.', '.', '.', '8', '.', '.'],
    ['9', '.', '.', '8', '.', '.', '.', '2', '.'],
    ['.', '5', '.', '.', '6', '9', '7', '8', '4'],
    ['4', '.', '.', '2', '5', '.', '.', '.', '.']
  ]

board2 =
  [ ['.', '.', '.', '1', '.', '.', '.', '.', '.'],
    ['.', '.', '.', '4', '.', '3', '.', '8', '5'],
    ['7', '.', '.', '.', '.', '.', '1', '9', '.'],
    ['.', '5', '.', '3', '.', '.', '.', '2', '9'],
    ['.', '.', '.', '.', '2', '.', '.', '.', '.'],
    ['1', '8', '.', '.', '.', '4', '.', '3', '.'],
    ['.', '4', '1', '.', '.', '.', '.', '.', '2'],
    ['6', '2', '.', '5', '.', '7', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '8', '.', '.', '.']
  ]

type Matrix a = [[a]]

type Board = Matrix Char

boxsize = 3

allvals = "123456789"

blank c = c == '.'

correct :: Board -> Bool
correct b =
  all nodups (rows b) &&
  all nodups (cols b) &&
  all nodups (boxes b)

nodups [] = True
nodups (x:xs) =  x `notElem` xs &&  nodups xs

rows = id

cols [] = replicate (boxsize ^ 2) []
cols (x:xs) = zipWith (:) x (cols xs)

boxes = map unchop . unchop  . map cols  .  chop   .  map chop

chop = chopBy boxsize
   where chopBy b [] = []
         chopBy b l = (take b l) : chopBy b (drop b l)

unchop = concat

type Choices = [Char]

fillin c
   | blank c = allvals
   | otherwise = [c]

initialChoices :: Board -> Matrix Choices
initialChoices = map (map fillin)

cp [] = [[]]
cp (x:xs) = [ y:ys | y <- x, ys <- cp xs]

mcp = cp . (map cp)


sudokusolver1 =  filter correct . mcp . initialChoices 