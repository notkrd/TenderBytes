`Twas brillig, and the slithy toves
  Did gyre and gimble in the wabe:
All mimsy were the borogoves,
  And the mome raths outgrabe.

“Beware the Jabberwock, my son!
      The jaws that bite, the claws that catch!
Beware the Jubjub bird, and shun
      The frumious Bandersnatch!”

He took his vorpal sword in hand;
      Long time the manxome foe he sought—
So rested he by the Tumtum tree
      And stood awhile in thought.

And, as in uffish thought he stood,
      The Jabberwock, with eyes of flame,
Came whiffling through the tulgey wood,
      And burbled as it came!

One, two! One, two! And through and through
      The vorpal blade went snicker-snack!
He left it dead, and with its head
      He went galumphing back.

“And hast thou slain the Jabberwock?
      Come to my arms, my beamish boy!
O frabjous day! Callooh! Callay!”
      He chortled in his joy.

`Twas brillig, and the slithy toves
      Did gyre and gimble in the wabe:
All mimsy were the borogoves,
      And the mome raths outgrabe.

-Lewis Carroll, \emph{Through the Looking Glass}

\section{Paperwork}

\begin{code}
module MakingLines where

import PoemUnits
import PoemDicts
import PoemDictionaries
import System.Random
\end{code}

\section{Line Generators}

\begin{code}
--From the given dictionary produces, with a Mysterious Force of Poetic Insight, in the tradition of Duchamp, a word,
--and a new Mysterious Force Of Poetic Insight
chooseRandWord :: (PoemUnit a) => Dictionary a -> Int -> StdGen -> (a, StdGen)
chooseRandWord [] _ g = (cellar_door,g)
chooseRandWord _ 0 g = (cellar_door,g)
chooseRandWord dict len g = let (i, g') = randomR (0, (length dict) - 1) g in let next_word = dict !! i in
                                if (syllablesInWord next_word) <= len
                                   then (next_word, g')
                                    else chooseRandWord (dictWithout dict i) len g'
                                    
--From the given dictionary produces, with a Mysterious Force of Poetic Insight, in the tradition of Duchamp, a word of
--less syllables than given length
--and a new Mysterious Force Of Poetic Insight
chooseRandUnitThat :: (PoemDictionary d a) => d -> (a -> Bool) -> StdGen -> (Maybe a, StdGen)
chooseRandUnitThat dict some_condition g = case (get_rand_elt dict g) of 
    (Nothing, g') -> (Nothing, g')
    (Just the_unit, g') -> if some_condition the_unit
            then (Just the_unit, g')
            else chooseRandUnitThat (remove_from_dict dict the_unit) some_condition g'
\end{code}

From this we get, "for free," the ability to get a unit of less than a given syllabic length.

\begin{code}
chooseRandWordLen :: (PoemDictionary d a) => d -> Int -> StdGen -> (Maybe a, StdGen)
chooseRandWordLen dict n g = chooseRandUnitThat dict (\a -> syllablesInWord a <= n) g
\end{code}

\begin{code}

--From the given dictionary and with a given len produces, with a Mysterious Force of Poetic Insight, a word, a line
--of syllableCount <= len and a new Mysterious Force Of Poetic Insight

writeRandLineOfLength :: (PoemUnit a) => Dictionary a -> Int -> StdGen -> ([a], StdGen)
writeRandLineOfLength dict len g
    | len <= 0 = ([cellar_door], g)
    | dict == [] = ([cellar_door], g)
    | otherwise = let next_word = (chooseRandWord dict len g) in 
                      let rest_of_line = (writeRandLineOfLength dict (len - (syllablesInWord (fst next_word))) (snd next_word)) in
                          ((fst next_word) : (fst rest_of_line), (snd rest_of_line))
\end{code}