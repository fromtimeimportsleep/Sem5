ready :: IO Bool
ready = do c <- getChar
           return (c == 'y')
