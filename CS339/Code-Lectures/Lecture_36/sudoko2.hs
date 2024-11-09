--import Data.List

type Matrix a = [[a]]

type Board = Matrix Char


board1 :: Matrix Char
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

board2 :: Matrix Char
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


boxsize :: Int
boxsize = 3

allvals :: String
allvals = "123456789"

blank :: Char -> Bool
blank c = c == '.'

correct :: Eq a => [[a]] -> Bool
correct b =
  all nodups (rows b) &&
  all nodups (cols b) &&
  all nodups (boxes b)

nodups :: Eq a => [a] -> Bool
nodups [] = True
nodups (x:xs) =  x `notElem` xs &&  nodups xs

rows :: a -> a
rows = id

cols :: [[a]] -> [[a]]
cols [] = replicate (boxsize ^ 2) []
cols (x:xs) = zipWith (:) x (cols xs)

boxes :: [[a]] -> [[a]]
boxes = map unchop . unchop  . map cols  .  chop   .  map chop

chop :: [a] -> [[a]]
chop = chopBy boxsize
   where chopBy b [] = []
         chopBy b l = (take b l) : chopBy b (drop b l)

unchop :: [[a]] -> [a]
unchop = concat

type Choices = [Char]

fillin :: Char -> String
fillin c
   | blank c = allvals
   | otherwise = [c]

initialChoices :: Board -> Matrix Choices
initialChoices = map (map fillin)

cp :: [[a]] -> [[a]]
cp [] = [[]]
cp (x:xs) = [ y:ys | y <- x, ys <- cp xs]

mcp :: [[[a]]] -> [[[a]]]
mcp = cp . (map cp)

---------------------------------------------
sudokusolver1 :: Board -> Board
sudokusolver1 =  head . filter correct . mcp . initialChoices 

fixed :: [[a]] -> [a]
fixed cl = [s | [s] <- cl]

remove :: (Eq a) => [a] -> [a] -> [a]
remove fs [c] = [c]
remove fs cs = [ c | c <- cs, c `notElem` fs]

single :: [a] -> Bool
single [_] = True
single _ = False

pruneList :: Eq a => [[a]] -> [[a]]
pruneList css = [remove fs cs |  cs <- css]
                 where fs = fixed css

pruneBy :: Eq a => ([[[a]]] -> [[[a]]]) -> [[[a]]] -> [[[a]]]
pruneBy f = f . (map pruneList) . f


prune :: (Eq a) => [[[a]]] -> [[[a]]]
prune   = pruneBy rows . pruneBy cols . pruneBy boxes

sudokusolver2 :: Board -> Board
sudokusolver2 = head . filter correct . mcp . prune . initialChoices

-------------------------------------------------

blocked :: Eq a => [[[a]]] -> Bool
blocked cm = void cm || not (safe cm)

void :: [[[a]]] -> Bool
void cm = any (any null) cm

safe :: Eq a => [[[a]]] -> Bool
safe cm = all (nodups . fixed) (rows cm) &&
          all (nodups .fixed) (cols cm) &&
          all (nodups . fixed) (boxes cm)

minchoice :: [[[a]]] -> Int
minchoice  = minimum .  (filter (> 1)) . map length . concat

expand :: [[[t]]] -> [[[[t]]]]
expand cm = [rows1 ++ (row1 ++ [c]:row2 ):rows2 | c <- cs]
   where isCandidate cs = length cs == minchoice cm
         (rows1, row:rows2) = break (any isCandidate) cm
         (row1, cs:row2) = break isCandidate row


expandprune cm 
  | blocked cm = []
  | all (all single) cm = [cm]
  | otherwise = [b | cm' <- expand cm,
                     b <- expandprune(prune cm')]

sudokusolver3 :: Board -> Board
sudokusolver3 = map (map head). head . expandprune . initialChoices
