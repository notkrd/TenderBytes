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
                                if (syllablesInUnit next_word) <= len
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
chooseRandUnitLen :: (PoemDictionary d a) => d -> Int -> StdGen -> (Maybe a, StdGen)
chooseRandUnitLen dict n g = chooseRandUnitThat dict (\a -> syllablesInUnit a <= n) g
\end{code}

\begin{code}

--From the given dictionary and with a given len produces, with a Mysterious Force of Poetic Insight, a line
--of syllableCount <= len and a new Mysterious Force Of Poetic Insight

writeRandLineOfLength :: (PoemUnit a) => Dictionary a -> Int -> StdGen -> ([a], StdGen)
writeRandLineOfLength dict len g
    | len <= 0 = ([cellar_door], g)
    | dict == [] = ([cellar_door], g)
    | otherwise = let next_word = (chooseRandWord dict len g) in 
                      let rest_of_line = (writeRandLineOfLength dict (len - (syllablesInUnit (fst next_word))) (snd next_word)) in
                          ((fst next_word) : (fst rest_of_line), (snd rest_of_line))
\end{code}

From a given PoemDictionary and with a given length we can pdoruce, with a Mysterious Force of Poetic Insight, a number of units
with syllables <= len and a new Mysterious Force Of Poetic Insight, so we can stay inspired.

\begin{code}
genRandLineOfLength :: (PoemUnit a, PoemDictionary d a) => d -> Int -> StdGen -> ([a], StdGen)
genRandLineOfLength dict len g
    | len <= 0 = ([], g)
    | otherwise = case chooseRandUnitLen dict len g of
        (Nothing, _) -> ([], g)
        (Just next_unit, g') -> let (rest_of_line, g'') = (genRandLineOfLength dict (len - (syllablesInUnit next_unit)) g') in
                            (next_unit : rest_of_line, g'')
                            
genRandLinesOfLengths :: (PoemUnit a, PoemDictionary d a) => d -> [Int] -> StdGen -> ([a], StdGen)
genRandLinesOfLengths _ [] g = ([], g)
genRandLinesOfLengths dict (first_length : remaining_lengths) g = let (next_line, g') = genRandLineOfLength dict first_length g in
        let (remaining_lines, g'') = genRandLinesOfLengths dict remaining_lengths g' in
            (next_line ++ ((justWord "\n") : remaining_lines), g'')
\end{code}

We can also create sentences that match some labels, from lists of labeled words. 
\begin{code}
{-# LANGUAGE FlexibleContexts #-}
genRandLineOfLabels :: (PoemDictionary d LabeledWord) => d -> [String] -> StdGen -> ([LabeledWord], StdGen)
genRandLineOfLabels _ [] g = ([], g)
genRandLineOfLabels dict (first_label : other_labels) g
    | dict == empty_dict = ([], g)
    | otherwise = case chooseRandUnitThat dict (\some_unit -> (the_label some_unit) == first_label) g of
        (Nothing, g') -> (genRandLineOfLabels dict other_labels g')
        (Just some_unit, g') -> let (rest_of_line, g'') = genRandLineOfLabels dict other_labels g' in
            (some_unit : rest_of_line, g'')
\end{code}

Some examples and test cases below:

\begin{code}
writeAPoem :: (PoemUnit a) => [a] -> String
writeAPoem [] = ""
writeAPoem (first_unit : other_units)
    | writeIt first_unit == "\n" = "\n" ++ writeAPoem other_units
    | otherwise = (writeIt first_unit) ++ " " ++ writeAPoem other_units

makingLinesTests :: IO ()
makingLinesTests = do
    g <- newStdGen
    not_a_haiku <- return (fst (genRandLinesOfLengths jabber_dict [5,7,5] g))
    putStrLn (writeAPoem not_a_haiku)
    g' <- newStdGen
    hopefully_a_sentence <- return (fst (genRandLineOfLabels jabber_dict_labeled ["the", "A", "N", "V", "the", "A", "N"] g'))
    putStrLn (writeAPoem hopefully_a_sentence)
\end{code}