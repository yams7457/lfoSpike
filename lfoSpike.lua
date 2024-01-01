lattice = require("lattice")
_lfos = require 'lfo'
m = midi.connect()


-- interface elements for 'every' (based on bitwise operators?)
-- come up with a better way of selecting the last chord in the progression
-- fix 'chirps' (look into dewb's suggested note management implentation)


pentadDistances = {

    {0, 2, 4, 7, 10},
    {0, 2, 4, 5, 7},
    {0, 4, 5, 7, 10},
    {0, 2, 4, 6, 7},
    {0, 2, 4, 7, 9},
    {0, 4, 7, 9, 10},
    {0, 2, 4, 7, 11},
    {0, 2, 3, 7, 10},
    {0, 2, 3, 5, 7},
    {0, 2, 3, 7, 9},
    {0, 3, 7, 9, 10},
    {0, 2, 4, 9, 10},
   
    {1, 3, 5, 8, 11},
    {1, 3, 5, 6, 8},
    {1, 5, 6, 8, 11},
    {1, 3, 5, 7, 8},
    {1, 3, 5, 8, 10},
    {1, 5, 8, 10, 11},
    {0, 1, 3, 5, 8},
    {1, 3, 4, 8, 11},
    {1, 3, 4, 6, 8},
    {1, 3, 4, 8, 10},
    {1, 4, 8, 10, 11},
    {1, 3, 5, 10, 11},
   
    {0, 2, 4, 6, 9},
    {2, 4, 6, 7, 9},
    {0, 2, 6, 7, 9},
    {2, 4, 6, 8, 9},
    {2, 4, 6, 9, 11},
    {0, 2, 6, 9, 11},
    {1, 2, 4, 6, 9},
    {0, 2, 4, 5, 9},
    {2, 4, 5, 7, 9},
    {2, 4, 5, 9, 11},
    {0, 2, 5, 9, 11},
    {0, 2, 4, 6, 11},
   
    {1, 3, 5, 7, 10},
    {3, 5, 7, 8, 10},
    {1, 3, 7, 8, 10},
    {3, 5, 7, 9, 10},
    {0, 3, 5, 7, 10},
    {0, 1, 3, 7, 10},
    {2, 3, 5, 7, 10},
    {1, 3, 5, 6, 10},
    {3, 5, 6, 8, 10},
    {0, 3, 5, 6, 10},
    {0, 1, 3, 6, 10},
    {0, 1, 3, 5, 7},
   
    {2, 4, 6, 8, 11},
    {4, 6, 8, 9, 11},
    {2, 4, 8, 9, 11},
    {4, 6, 8, 10, 11},
    {1, 4, 6, 8, 11},
    {1, 2, 4, 8, 11},
    {3, 4, 6, 8, 11},
    {2, 4, 6, 7, 11},
    {4, 6, 7, 9, 11},
    {1, 4, 6, 7, 11},
    {1, 2, 4, 7, 11},
    {1, 2, 4, 6, 8},
   
    {0, 3, 5, 7, 9},
    {0, 5, 7, 9, 10},
    {0, 3, 5, 9, 10},
    {0, 5, 7, 9, 11},
    {0, 2, 5, 7, 9},
    {0, 2, 3, 5, 9},
    {0, 4, 5, 7, 9},
    {0, 3, 5, 7, 8},
    {0, 5, 7, 8, 10},
    {0, 2, 5, 7, 8},
    {0, 2, 3, 5, 8},
    {2, 3, 5, 7, 9},
   
    {1, 4, 6, 8, 10},
    {1, 6, 8, 10, 11},
    {1, 4, 6, 10, 11},
    {0, 1, 6, 8, 10},
    {1, 3, 6, 8, 10},
    {1, 3, 4, 6, 10},
    {1, 5, 6, 8, 10},
    {1, 4, 6, 8, 9},
    {1, 6, 8, 9, 11},
    {1, 3, 6, 8, 9},
    {1, 3, 4, 6, 9},
    {3, 4, 6, 8, 10},
   
    {2, 5, 7, 9, 11},
    {0, 2, 7, 9, 11},
    {0, 2, 5, 7, 11},
    {1, 2, 7, 9, 11},
    {2, 4, 7, 9, 11},
    {2, 4, 5, 7, 11},
    {2, 6, 7, 9, 11},
    {2, 5, 7, 9, 10},
    {0, 2, 7, 9, 10},
    {2, 4, 7, 9, 10},
    {2, 4, 5, 7, 10},
    {4, 5, 7, 9, 11},
   
    {0, 3, 6, 8, 10},
    {0, 1, 3, 8, 10},
    {0, 1, 3, 6, 8},
    {0, 2, 3, 8, 10},
    {0, 3, 5, 8, 10},
    {0, 3, 5, 6, 8},
    {0, 3, 7, 8, 10},
    {3, 6, 8, 10, 11},
    {1, 3, 8, 10, 11},
    {3, 5, 8, 10, 11},
    {3, 5, 6, 8, 11},
    {0, 5, 6, 8, 10},
   
    {1, 4, 7, 9, 11},
    {1, 2, 4, 9, 11},
    {1, 2, 4, 7, 9},
    {1, 3, 4, 9, 11},
    {1, 4, 6, 9, 11},
    {1, 4, 6, 7, 9},
    {1, 4, 8, 9, 11},
    {0, 4, 7, 9, 11},
    {0, 2, 4, 9, 11},
    {0, 4, 6, 9, 11},
    {0, 4, 6, 7, 9},
    {1, 6, 7, 9, 11},
   
    {0, 2, 5, 8, 10},
    {0, 2, 3, 5, 10},
    {2, 3, 5, 8, 10},
    {0, 2, 4, 5, 10},
    {0, 2, 5, 7, 10},
    {2, 5, 7, 8, 10},
    {0, 2, 5, 9, 10},
    {0, 1, 5, 8, 10},
    {0, 1, 3, 5, 10},
    {0, 1, 5, 7, 10},
    {1, 5, 7, 8, 10},
    {0, 2, 7, 8, 10},

    {1, 3, 6, 9, 11},
    {1, 3, 4, 6, 11},
    {3, 4, 6, 9, 11},
    {1, 3, 5, 6, 11},
    {1, 3, 6, 8, 11},
    {3, 6, 8, 9, 11},
    {1, 3, 6, 10, 11},
    {1, 2, 6, 9, 11},
    {1, 2, 4, 6, 11},
    {1, 2, 6, 8, 11},
    {2, 6, 8, 9, 11},
    {1, 3, 8, 9, 11}
}

-- pentad functions is a table that contains the potential root notes and potential functions of each pentadDistances table

heldNotes = {}
for i = 1,3 do heldNotes[i] = {} end

compUp = {-7, -4, -3, -2, 3, 4, 6, 7}

pentadFunctions = {
    {{2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}}, {{0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {11, 'Minor'}}, {{2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}}, {{0, 'Major'}, {4, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}}, {{0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {6, 'Minor'}, {7, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {10, 'Major'}, {11, 'Minor'}}, {{2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}}, {{0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}}, {{0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {9, 'Minor'}, {10, 'Major'}}, {{0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {9, 'Minor'}, {10, 'Major'}}, {{0, 'Minor'}, {2, 'Minor'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}}, {{0, 'Minor'}, {3, 'Minor'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}}, {{2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}},
    {{3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}}, {{1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {12, 'Minor'}}, {{3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}}, {{1, 'Major'}, {5, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {12, 'Minor'}}, {{1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {7, 'Minor'}, {8, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {11, 'Major'}, {12, 'Minor'}}, {{3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}}, {{1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {12, 'Minor'}}, {{1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {10, 'Minor'}, {11, 'Major'}}, {{1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {10, 'Minor'}, {11, 'Major'}}, {{1, 'Minor'}, {3, 'Minor'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}}, {{1, 'Minor'}, {4, 'Minor'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}}, {{3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}},
    {{4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}}, {{2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {1, 'Minor'}}, {{4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}}, {{2, 'Major'}, {6, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}}, {{2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {8, 'Minor'}, {9, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {0, 'Major'}, {1, 'Minor'}}, {{4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}}, {{2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}}, {{2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {11, 'Minor'}, {0, 'Major'}}, {{2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {11, 'Minor'}, {0, 'Major'}}, {{2, 'Minor'}, {4, 'Minor'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}}, {{2, 'Minor'}, {5, 'Minor'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}}, {{4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}},
    {{5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}}, {{3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {2, 'Minor'}}, {{5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}}, {{3, 'Major'}, {7, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}}, {{3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {9, 'Minor'}, {10, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {1, 'Major'}, {2, 'Minor'}}, {{5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}}, {{3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}}, {{3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {0, 'Minor'}, {1, 'Major'}}, {{3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {0, 'Minor'}, {1, 'Major'}}, {{3, 'Minor'}, {5, 'Minor'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}}, {{3, 'Minor'}, {6, 'Minor'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}}, {{5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}},
    {{6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}}, {{4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {3, 'Minor'}}, {{6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}}, {{4, 'Major'}, {8, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}}, {{4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {10, 'Minor'}, {11, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {2, 'Major'}, {3, 'Minor'}}, {{6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}}, {{4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}}, {{4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {1, 'Minor'}, {2, 'Major'}}, {{4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {1, 'Minor'}, {2, 'Major'}}, {{4, 'Minor'}, {6, 'Minor'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}}, {{4, 'Minor'}, {7, 'Minor'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}}, {{6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}},
    {{7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}}, {{5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {4, 'Minor'}}, {{7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}}, {{5, 'Major'}, {9, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}}, {{5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {11, 'Minor'}, {0, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {3, 'Major'}, {4, 'Minor'}}, {{7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}}, {{5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}}, {{5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {2, 'Minor'}, {3, 'Major'}}, {{5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {2, 'Minor'}, {3, 'Major'}}, {{5, 'Minor'}, {7, 'Minor'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}}, {{5, 'Minor'}, {8, 'Minor'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}}, {{7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}},
    {{8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}}, {{6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {5, 'Minor'}}, {{8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}}, {{6, 'Major'}, {10, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}}, {{6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {0, 'Minor'}, {1, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {4, 'Major'}, {5, 'Minor'}}, {{8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}}, {{6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}}, {{6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {3, 'Minor'}, {4, 'Major'}}, {{6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {3, 'Minor'}, {4, 'Major'}}, {{6, 'Minor'}, {8, 'Minor'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}}, {{6, 'Minor'}, {9, 'Minor'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}}, {{8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}},
    {{9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}}, {{7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {6, 'Minor'}}, {{9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}}, {{7, 'Major'}, {11, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}}, {{7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {1, 'Minor'}, {2, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {5, 'Major'}, {6, 'Minor'}}, {{9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}}, {{7, 'Major'}, {9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}}, {{7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {4, 'Minor'}, {5, 'Major'}}, {{7, 'Minor'}, {9, 'Minor'}, {10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {4, 'Minor'}, {5, 'Major'}}, {{7, 'Minor'}, {9, 'Minor'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}}, {{7, 'Minor'}, {10, 'Minor'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}}, {{9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}},
    {{10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}}, {{8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {7, 'Minor'}}, {{10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}}, {{8, 'Major'}, {0, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}}, {{8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {2, 'Minor'}, {3, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {6, 'Major'}, {7, 'Minor'}}, {{10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}}, {{8, 'Major'}, {10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}}, {{8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {5, 'Minor'}, {6, 'Major'}}, {{8, 'Minor'}, {10, 'Minor'}, {11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {5, 'Minor'}, {6, 'Major'}}, {{8, 'Minor'}, {10, 'Minor'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}}, {{8, 'Minor'}, {11, 'Minor'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}}, {{10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}},
    {{11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}}, {{9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {8, 'Minor'}}, {{11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}}, {{9, 'Major'}, {1, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}}, {{9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {3, 'Minor'}, {4, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {7, 'Major'}, {8, 'Minor'}}, {{11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}}, {{9, 'Major'}, {11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}}, {{9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {6, 'Minor'}, {7, 'Major'}}, {{9, 'Minor'}, {11, 'Minor'}, {0, 'Major'}, {2, 'Minor'}, {4, 'Minor'}, {5, 'Major'}, {6, 'Minor'}, {7, 'Major'}}, {{9, 'Minor'}, {11, 'Minor'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}}, {{9, 'Minor'}, {0, 'Minor'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}}, {{11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}},
    {{0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}}, {{10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}, {9, 'Minor'}}, {{0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}}, {{10, 'Major'}, {2, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}}, {{10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {4, 'Minor'}, {5, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {8, 'Major'}, {9, 'Minor'}}, {{0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}}, {{10, 'Major'}, {0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {4, 'Minor'}, {5, 'Major'}, {7, 'Minor'}, {9, 'Minor'}}, {{10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {7, 'Minor'}, {8, 'Major'}}, {{10, 'Minor'}, {0, 'Minor'}, {1, 'Major'}, {3, 'Minor'}, {5, 'Minor'}, {6, 'Major'}, {7, 'Minor'}, {8, 'Major'}}, {{10, 'Minor'}, {0, 'Minor'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}}, {{10, 'Minor'}, {1, 'Minor'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}}, {{0, 'Minor'}, {2, 'Minor'}, {3, 'Major'}, {5, 'Minor'}, {7, 'Minor'}, {8, 'Major'}},
    {{1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}}, {{11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}, {10, 'Minor'}}, {{1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}}, {{11, 'Major'}, {3, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}}, {{11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {5, 'Minor'}, {6, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {9, 'Major'}, {10, 'Minor'}}, {{1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}}, {{11, 'Major'}, {1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {5, 'Minor'}, {6, 'Major'}, {8, 'Minor'}, {10, 'Minor'}}, {{11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {8, 'Minor'}, {9, 'Major'}}, {{11, 'Minor'}, {1, 'Minor'}, {2, 'Major'}, {4, 'Minor'}, {6, 'Minor'}, {7, 'Major'}, {8, 'Minor'}, {9, 'Major'}}, {{11, 'Minor'}, {1, 'Minor'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}}, {{11, 'Minor'}, {2, 'Minor'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}}, {{1, 'Minor'}, {3, 'Minor'}, {4, 'Major'}, {6, 'Minor'}, {8, 'Minor'}, {9, 'Major'}}
}

pentadMovements = {"Major", "Minor"}

pentadMovements["Major"] = {"Major", "Minor"}
pentadMovements["Minor"] = {"Major", "Minor"}

pentadMovements["Major"]["Major"] = {5, 7}
pentadMovements["Major"]["Minor"] = {2, 4, 7, 9, 11}
pentadMovements["Minor"]["Major"] = {1, 3, 5, 8, 10}
pentadMovements["Minor"]["Minor"] = {2, 3, 5, 7, 9, 10}

qualityNames = {"Major", "Minor"}

lastMelodyIndex = 1
lastMelodyOctave = 48

melStep = 0
compStep = 0
bassStep = 0
pentadStep = 0

previousPentads = {}

function init()
    for i = 1,16 do
        m:cc(123, 0, i)
    end
    addParams()
    createLFOs()
    currentPentad = math.random(1,144)
    table.insert(previousPentads, currentPentad)
    makeBassCollection(currentPentad)
    my_lattice = lattice:new{
        auto = true,
        ppqn = 96
      }
    sprocket_a = my_lattice:new_sprocket{
        action = function(t) playNote() end,
        division = 1/16,
        enabled = true
      }
      sprocket_b = my_lattice:new_sprocket{
        action = function(t) playComp() end,
        division = 1/16,
        enabled = true
      }
      sprocket_c = my_lattice:new_sprocket{
        action = function(t) playBassNote() end,
        division = 1/16,
        enabled = true
      }
      sprocket_d = my_lattice:new_sprocket{
        action = function(t) findCurrentPentadPosition(qualityNames[math.random(1,2)], qualityNames[math.random(1,2)]) end,
        division = 1/4,
        enabled = true
      }
    my_lattice:start()
end

function playNote()
    melStep = melStep + 1
    if math.random(1,100) <= params:get('melodyProb') and melStep >= params:get('melEvery') then
        lastMelodyIndex = math.ceil((melLfo:get('scaled') - 1)) % 5 + 1
        lastMelodyOctave = math.ceil((melLfo:get('scaled') - 1) / 5) * 12 + 48
        m:note_on(pentadDistances[currentPentad][lastMelodyIndex] + lastMelodyOctave, math.random(70, 127), 1)
        print(pentadDistances[currentPentad][lastMelodyIndex])
        releaseTimer(pentadDistances[currentPentad][lastMelodyIndex] + lastMelodyOctave, 1)
        melStep = melStep % params:get('melEvery')
    end
end

function playComp()
    compStep = compStep + 1
    if math.random(1,100) <= params:get('compProb') and compStep >= params:get('compEvery') then
        lastComp = pentadDistances[currentPentad][(lastMelodyIndex + 9 - math.ceil(compLfo:get('scaled'))) % 5 + 1] + lastMelodyOctave

        m:note_on(lastComp, math.random(70, 127), 2)
        releaseTimer(lastComp, 2)
        compStep = compStep % params:get('compEvery')
    end
end

function playBassNote()
    bassStep = bassStep + 1
    if math.random(1,100) <= params:get('bassProb') and bassStep >= params:get('bassEvery') then
        lastBass = bassCollection[math.ceil(bassLfo:get('scaled'))]
        
        m:note_on(lastBass + 24, math.random(70, 127), 3)
        releaseTimer(lastBass + 24, 3)
        bassStep = bassStep % params:get('bassEvery')
    end
end


function findCurrentPentadPosition(startQuality, endQuality)
    if #previousPentads >= 4 then
        pentadStep = pentadStep % 4 + 1
        currentPentad = previousPentads[pentadStep]
    else
        local choices = {}
        for i  = 1,#pentadFunctions[currentPentad] do
            choices[i] = pentadFunctions[currentPentad][i]
      end
      if startQuality ~= nil then 
         for i = #choices, 1, -1 do
             if startQuality ~= choices[i][2] then
                 table.remove(choices, i)
             end
         end
     end
        local moveAmount = pentadMovements[startQuality][endQuality][math.random(1, #pentadMovements[startQuality][endQuality])]
        findNextPentadPosition(startQuality, endQuality, choices, moveAmount)
    end
end

function findNextPentadPosition(startQuality, endQuality, choices, moveAmount)
    local legalDestinations = {}
    for i =1, #choices do
        table.insert(legalDestinations, (choices[i][1] + moveAmount) % 12)
    end
    tab.sort(legalDestinations)
    find_matching_tables(legalDestinations, endQuality)
end

function find_matching_tables(numbers, target_string)
    local matching_indices = {}
    for j = 1,144 do
        for i, pft in ipairs(pentadFunctions[j]) do
            local num, str = pft[1], pft[2]
            for _, number in ipairs(numbers) do
                if num == number and str == target_string then
                    table.insert(matching_indices, j)
                    break
                end
            end
        end
    end
    matching_indices = removeDuplicates(matching_indices)
    local matches = {}

    -- Function to count matching elements between two tables
    local function countMatches(table1, table2)
        local count = 0
        for i = 1, #table1 do
            for j = 1, #table2 do
                if table1[i] == table2[j] then
                    count = count + 1
                end
            end
        end
        return count
    end

    -- Check each index in matching_indices
    for i = 1, #matching_indices do
        local index = matching_indices[i]
        if pentadDistances[index] and countMatches(pentadDistances[currentPentad], pentadDistances[index]) >= 3 and countMatches(pentadDistances[currentPentad], pentadDistances[index]) <= 4 then
            table.insert(matches, index)
        end
    end

    local i = 1
    while i <= #matches do
        local match = matches[i]
        local pentadDistance = pentadDistances[match]
        local targetValue = pentadDistances[currentPentad][lastMelodyIndex]

        local found = false
        for _, value in ipairs(pentadDistance) do
            if value == targetValue then
                found = true
                break
            end
        end

        if not found then
            table.remove(matches, i)
        else
            i = i + 1
        end
    end
    if #matches >= 1 then
        currentPentad = matches[math.random(1, #matches)]
        table.insert(previousPentads, currentPentad)
        makeBassCollection(currentPentad)
    end
end

function removeDuplicates(tbl)
    local unique = {}
    local result = {}
    for _, v in ipairs(tbl) do
        if not unique[v] then
            unique[v] = true
            table.insert(result, v)
        end
    end
    return result
end


function createModifiedTable(originalTable)
    -- Function to check if a table contains a value
    local function contains(table, val)
        for i = 1, #table do
            if table[i] == val then
                return true
            end
        end
        return false
    end

    -- Step 2: Create a new table with modified values
    local newTable = {}
    for _, val in ipairs(originalTable) do
        table.insert(newTable, val)
        table.insert(newTable, (val + 12 - 3) % 12)
        table.insert(newTable, (val + 12 - 7) % 12)
    end

    -- Step 3: Remove duplicates
    local uniqueTable = {}
    for _, val in ipairs(newTable) do
        if not contains(uniqueTable, val) then
            table.insert(uniqueTable, val)
        end
    end

    -- Step 4: Apply %12 to all values
    for i, val in ipairs(uniqueTable) do
        uniqueTable[i] = val % 12
    end

    -- Step 5: Remove specific values
    local finalTable = {}
    for _, val in ipairs(uniqueTable) do
        local valid = true
        for _, origVal in ipairs(originalTable) do
            if val == (origVal - 1) % 12 or val == (origVal - 6) % 12 then
                valid = false
                break
            end
        end
        if valid then
            table.insert(finalTable, val)
        end
    end

    -- Step 6: Sort the final table
    table.sort(finalTable)

    return finalTable
end

function makeBassCollection(pentadIndex)
    bassCollection = createModifiedTable(pentadDistances[pentadIndex])
    local bassSize = #bassCollection
    for i = 1, bassSize do
        bassCollection[i + bassSize] = bassCollection[i] + 12
        bassCollection[i + bassSize * 2] = bassCollection[i] + 24
    end
end

function addParams()

    params:add_number(
        "jumpProb", -- id
        "jump probability", -- name
        0, -- min
        100, -- max
        10, -- default
        false -- wrap
        )

    params:add_number(
        "melodyProb", -- id
        "melody probability", -- name
        0, -- min
        100, -- max
        50, -- default
        false -- wrap
        )
    
    params:add_number(
        "compProb", -- id
        "comp probability", -- name
        0, -- min
        100, -- max
        50, -- default
        false -- wrap
        )
    
    params:add_number(
        "bassProb", -- id
        "bass probability", -- name
        0, -- min
        100, -- max
        50, -- default
        false -- wrap
        )
    
    params:add_number(
        "melEvery", -- id
        "melEvery", -- name
        1, -- min
        96, -- max
        math.random(1, 8), -- default
        false -- wrap
        )
    
    params:add_number(
        "compEvery", -- id
        "compEvery", -- name
        1, -- min
        96, -- max
        math.random(1,8), -- default
        false -- wrap
        )
    
    params:add_number(
        "bassEvery", -- id
        "bassEvery", -- name
        1, -- min
        96, -- max
        math.random(1,8), -- default
        false -- wrap
        )

  params:add{
    type = "control",
    id = "melCycle",
    name = "melCycle",
    controlspec = controlspec.def{
      min = .01,
      max = 45,
      warp = 'lin',
      step = 0.01, -- allows decimal increments
      default = math.random(100, 1200) / 100,
      units = 's'
    }
  }

  params:add{
    type = "control",
    id = "melRatio",
    name = "melRatio",
    controlspec = controlspec.def{
      min = 1,
      max = 99,
      warp = 'lin',
      step = 1, -- allows decimal increments
      default = math.random(1,99)
    }
  }


  params:add{
    type = "control",
    id = "melMin",
    name = "melMin",
    controlspec = controlspec.def{
      min = 1,
      max = 18,
      warp = 'lin',
      default = 1
    }
  }

  params:add{
    type = "control",
    id = "melRange",
    name = "melRange",
    controlspec = controlspec.def{
      min = 1,
      max = 18,
      warp = 'lin',
      default = 18
    }
  }


params:add_number(
    "melSustain", -- id
    "melody sustain", -- name
    1, -- min
    64, -- max
    1, -- default
    false -- wrap
    )

    params:add{
        type = "control",
        id = "compCycle",
        name = "compCycle",
        controlspec = controlspec.def{
          min = .01,
          max = 45,
          warp = 'lin',
          step = 0.01, -- allows decimal increments
          default = math.random(100,1200) / 100,
          units = 's'
        }
      }
    
      params:add{
        type = "control",
        id = "compRatio",
        name = "compRatio",
        controlspec = controlspec.def{
          min = 1,
          max = 99,
          warp = 'lin',
          step = 1, -- allows decimal increments
          default = math.random(1,99)
        }
      }
    
    
      params:add{
        type = "control",
        id = "compMin",
        name = "compMin",
        controlspec = controlspec.def{
          min = 1,
          max = 7,
          warp = 'lin',
          default = 1
        }
      }
    
      params:add{
        type = "control",
        id = "compRange",
        name = "compRange",
        controlspec = controlspec.def{
          min = 1,
          max = 7,
          warp = 'lin',
          default = 7
      }
    }

      params:add_number(
        "compSustain", -- id
        "comp sustain", -- name
        1, -- min
        64, -- max
        1, -- default
        false -- wrap
        )

      params:add{
        type = "control",
        id = "bassCycle",
        name = "bassCycle",
        controlspec = controlspec.def{
          min = .01,
          max = 45,
          warp = 'lin',
          step = 0.01, -- allows decimal increments
          default = math.random(100, 1200) / 100,
          units = 's'
        }
      }
    
      params:add{
        type = "control",
        id = "bassRatio",
        name = "bassRatio",
        controlspec = controlspec.def{
          min = 1,
          max = 99,
          warp = 'lin',
          step = 1, -- allows decimal increments
          default = math.random(1,99)
        }
      }
    
    
      params:add{
        type = "control",
        id = "bassMin",
        name = "bassMin",
        controlspec = controlspec.def{
          min = 1,
          max = 9,
          warp = 'lin',
          default = 1
        }
      }
    
      params:add{
        type = "control",
        id = "bassRange",
        name = "bassRange",
        controlspec = controlspec.def{
          min = 1,
          max = 10,
          warp = 'lin',
          default = 10
        }
      }

      params:add_number(
        "bassSustain", -- id
        "bass sustain", -- name
        1, -- min
        64, -- max
        1, -- default
        false -- wrap
        )
end

function createLFOs()
    melLfo = _lfos.new(
        'tri', -- shape will default to 'sine'
        0, -- min
        18, -- max
        1, -- depth will default to 1
        'clocked', -- mode
        math.random(1,32), -- period (in 'clocked' mode, represents seconds)
      function(scaled, raw) melPoll(math.ceil(scaled), raw) end -- action, always passes scaled and raw values
    )

     melLfo:start() -- start our LFO, complements ':stop()'

     compLfo = _lfos.new(
        'tri', -- shape will default to 'sine'
        0, -- min
        8, -- max
        1, -- depth will default to 1
        'clocked', -- mode
        math.random(1,32), -- period (in 'clocked' mode, represents seconds)
      function(scaled, raw) compPoll(math.ceil(scaled), raw) end -- action, always passes scaled and raw values
    )

     compLfo:start() -- start our LFO, complements ':stop()'

     bassLfo = _lfos.new(
        'tri', -- shape will default to 'sine'
        0, -- min
        10, -- max
        1, -- depth will default to 1
        'clocked', -- mode
        math.random(1,32), -- period (in 'clocked' mode, represents seconds)
      function(scaled, raw) bassPoll(math.ceil(scaled), raw) end -- action, always passes scaled and raw values
    )

     bassLfo:start() -- start our LFO, complements ':stop()'

     params:set_action("melRange", function() melLfo:set('max', math.floor(math.min(18, params:get('melRange') + params:get('melMin')))) end)
     params:set_action("melMin", function() melLfo:set('max', math.floor(math.min(18, params:get('melRange') + params:get('melMin')))) melLfo:set('min', params:get('melMin')) end)
    --  params:set('melMin', math.random(1,15))
    --  params:set('melRange', math.random(2,18 - params:get('melMin')))
     params:set_action("compRange", function() compLfo:set('max', math.floor(math.min(8, params:get('compRange') + params:get('compMin')))) end)
     params:set_action("compMin", function() compLfo:set('max', math.floor(math.min(8, params:get('compRange') + params:get('compMin')))) compLfo:set('min', params:get('compMin')) end)
    --  params:set('compMin', math.random(1,15))
    --  params:set('compRange', math.random(2,18 - params:get('compMin')))
     params:set_action("bassRange", function() bassLfo:set('max', math.floor(math.min(10, params:get('bassRange') + params:get('bassMin')))) end)
     params:set_action("bassMin", function() bassLfo:set('max', math.floor(math.min(10, params:get('bassRange') + params:get('bassMin')))) bassLfo:set('min', params:get('bassMin')) end)
    --  params:set('bassMin', math.random(1,15))
    --  params:set('bassRange', math.random(2,18 - params:get('bassMin')))

end

function releaseTimer(pitch, ch)
    local sustain = 1
    if ch == 1 then
        sustain = params:get('melSustain')
    elseif ch == 2 then
        sustain = params:get('compSustain')
    elseif ch == 3 then
        sustain = params:get('bassSustain')
    end
    if heldNotes[ch][pitch] ~= nil then clock.cancel(heldNotes[ch][pitch]) end
    heldNotes[ch][pitch] = clock.run(function()
        -- Wait for two seconds
        clock.sync(sustain)
        m:note_off(pitch, 0, ch)
      end)
end

function melPoll(scaled, raw)
    if math.random(0,100) <= params:get('jumpProb') then
        jump(1)
    end
    if scaled >= 18 then
        melLfo:set('period', params:get('melCycle') * params:get('melRatio') / 100)
    elseif scaled <= 1 then
        melLfo:set('period', params:get('melCycle') * (100 - params:get('melRatio')) / 100)
    end
end

function compPoll(scaled, raw)
    if math.random(0,100) <= params:get('jumpProb') then
        jump(2)
    end
    if scaled >= 18 then
        compLfo:set('period', params:get('compCycle') * params:get('compRatio') / 100)
    elseif scaled <= 1 then
        compLfo:set('period', params:get('compCycle') * (100 - params:get('compRatio')) / 100)
    end
  end

function bassPoll(scaled, raw)
    if math.random(0,100) <= params:get('jumpProb') then
        jump(3)
    end
    if scaled >= 18 then
        bassLfo:set('period', params:get('bassCycle') * params:get('bassRatio') / 100)
    elseif scaled <= 1 then
        bassLfo:set('period', params:get('bassCycle') * (100 - params:get('bassRatio')) / 100)
    end
end

function jump(ch)
    if ch == 1 then
        melLfo:set('phase', math.random(0, 10) / 10)
    elseif ch == 2 then
        compLfo:set('phase', math.random(0, 10) / 10)
    elseif ch == 3 then
        bassLfo:set('phase', math.random(0, 10) / 10)
    end
end
