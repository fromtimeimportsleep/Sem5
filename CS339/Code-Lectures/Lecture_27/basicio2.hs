main = putStrLn ("Greetings! What is your name?") >>
       getLine >>= \x -> putStrLn ("Welcome to APP, " ++ x ++ "!")
