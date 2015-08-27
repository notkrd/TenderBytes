"Singing the way they did, in the old time, we can sometimes see through the tissues
and tracings the genetic process has laid down between us and them. The tendrils can
suggest a hand; or a specific color — the yellow of the tulip, for instance — will 
flash for a moment in such a way that after it has been withdrawn we can be sure that 
there was no imagining, no auto-suggestion here, but at the same time it becomes as 
useless as all subtracted memories. It has brought certainty without heat or light. 
Yet still in the old time, in the faraway summer evenings, they must have had a word 
for this, or known that we would someday need one, and wished to help."

-John Ashberry,  "Wherever it is, Wherever You Are"

\begin{code}
module PoemDictionaries where

import PoemUnits
import System.Random
\end{code}

We're going to try to define dictionaries in a more general way. We didn't care how a
dictionary is stored and published, we care about what it does: we want to be able
to look up words. And we want to be able to add and take away elements from a
dictionary. We also want to be able to take a list of words, and make it a dictionary.
We will probably also a want a way to get a random element from a dictionary.

Note: this implementation requires using the FunctionalDependencies extension.

\begin{code}
{-# LANGUAGE FunctionalDependencies #-}
class (Eq dict, PoemUnit unit) => PoemDictionary dict unit | dict -> unit where
    make_dict_from :: [unit] -> dict
    make_list_from :: dict -> [unit]
\end{code}

Given a way to  convert between dictionaries and lists, we can implement the rest of the functions.
It will probably be horendously inefficient though.

\begin{code}
    dict_contains :: dict -> unit -> Bool
    add_to_dict :: dict -> unit -> dict
    remove_from_dict :: dict -> unit -> dict
    get_rand_elt :: dict -> StdGen -> (Maybe unit, StdGen)
    empty_dict :: dict
\end{code}

Default implementations of remaining stuff. These should always give the correct values, but may
be highly inefficient.

\begin{code}
    dict_contains = \a_dict a_unit -> a_unit `elem` (make_list_from a_dict)
    add_to_dict = \a_dict unit_to_add -> make_dict_from (unit_to_add : make_list_from a_dict)
    remove_from_dict = \a_dict unit_to_remove -> make_dict_from (filter (/= unit_to_remove) (make_list_from a_dict))
    get_rand_elt = \a_dict g -> chooseRandWordFromList (make_list_from a_dict) g
    empty_dict = make_dict_from []
\end{code}

One example of a PoemDictionary is just a list of words. Again, this requires the FlexibleInstances
extension which hopefully doesn't involve secretly clubbing baby seals. 

\begin{code}
{-# LANGUAGE FlexibleInstances #-}

chooseRandWordFromList :: (PoemUnit a) => [a] -> StdGen -> (Maybe a, StdGen)
chooseRandWordFromList dict g
    |(dict == []) = (Nothing, g)
    |otherwise = let (i, g') = randomR (0, (length dict) - 1) g in let next_word = dict !! i in
                                (Just next_word, g')


instance (PoemUnit a) => PoemDictionary [a] a where
    add_to_dict = \d u -> u : d
    remove_from_dict = \d u -> filter (\w -> w /= u) d
    make_dict_from = id
    make_list_from = id
    get_rand_elt = chooseRandWordFromList
    dict_contains = \d u -> u `elem` d
\end{code}

Some examples for use in tests are below. 
\begin{code}
jabber_dict :: [String]
jabber_dict = ["twas","brillig","and","the","slithy","toves","did","gyre","and","gimble","in","the","wabes","all","mimsy","were","the","borogroves","and","the","mome","raths","outgrabe"]

jabber_dict_just :: [JustWord]
jabber_dict_just = map JustWord jabber_dict

jabber_adj_dict :: [LabeledWord]
jabber_adj_dict = map (\wrd -> LabeledWord wrd "A") ["brillig","slithy","mimsy","mome"]

jabber_noun_dict :: [LabeledWord]
jabber_noun_dict = map (\wrd -> LabeledWord wrd "N") ["toves","wabes","borogroves","raths"]

jabber_verb_dict :: [LabeledWord]
jabber_verb_dict = map (\wrd -> LabeledWord wrd "V") ["gyre","gymbal","were","outgrabe"]

jabber_misc_dict :: [LabeledWord]
jabber_misc_dict = map (\wrd -> LabeledWord wrd wrd) ["twas", "and", "the", "did", "in", "all", "were"]

jabber_dict_labeled :: [LabeledWord]
jabber_dict_labeled = jabber_adj_dict ++ jabber_noun_dict ++ jabber_verb_dict ++ jabber_misc_dict
\end{code}
