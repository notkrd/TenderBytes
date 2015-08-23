"Singing the way they did, in the old time, we can sometimes see through the tissues
and tracings the genetic process has laid down between us and them. The tendrils can
suggest a hand; or a specific color — the yellow of the tulip, for instance — will 
flash for a moment in such a way that after it has been withdrawn we can be sure that 
there was no imagining, no auto-suggestion here, but at the same time it becomes as 
useless as all subtracted memories. It has brought certainty without heat or light. 
Yet still in the old time, in the faraway summer evenings, they must have had a word 
for this, or known that we would someday need one, and wished to help."

-John Ashberry,  "Wherever it is, Wherever You Are"


>module PoemDicts where
>import PoemUnits

What happens when you have lots of words? You've got a dictionary! Dictionaries should
be of words, hopefully - particularly each element should be a PoemWord.

>type Dictionary a = [a]


For some reason, at some point, we might want to take a dictionary and get the list of
words inside it.

>wordsInDictionary :: (PoemUnit a) => Dictionary a -> [String]
>wordsInDictionary dict = map (write_it) dict

Sleeping with the Dictionary
BY HARRYETTE MULLEN

I beg to dicker with my silver-tongued companion, whose lips are ready to read my 
shining gloss. A versatile partner, conversant and well-versed in the verbal art, the 
dictionary is not averse to the solitary habits of the curiously wide-awake reader. In the 
dark night’s insomnia, the book is a stimulating sedative, awakening my tired
imagination to the hypnagogic trance of language. Retiring to the canopy of the 
bedroom, turning on the bedside light, taking the big dictionary to bed, clutching the 
unabridged bulk, heavy with the weight of all the meanings between these covers, 
smoothing the thin sheets, thick with accented syllables—all are exercises in the 
conscious regimen of dreamers, who toss words on their tongues while turning 
illuminated pages. To go through all these motions and procedures, groping in the 
dark for an alluring word, is the poet’s nocturnal mission. Aroused by myriad 
possibilities, we try out the most perverse positions in the practice of our nightly act, 
the penetration of the denotative body of the work. Any exit from the logic of language 
might be an entry in a symptomatic dictionary. The alphabetical order of this ample 
block of knowledge might render a dense lexicon of lucid hallucinations. Beside the 
bed, a pad lies open to record the meandering of migratory words. In the rapid eye 
movement of the poet’s night vision, this dictum can be decoded, like the secret 
acrostic of a lover’s name.
