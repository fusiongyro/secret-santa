% we have some couples and some single people
couple(phyllis, bob).
couple(oscar, gil).
couple(pam, roy).
couple(kelly, ryan).
couple(kevin, stacey).
couple(dwight, angela).
couple(stanley, teri).

parent(stacey, abby).
parent(jan, astrid).
parent(stanley, melissa).

% people not in a couple
person(michael).
person(meredith).
person(creed).
person(abby).
person(astrid).
person(melissa).
person(jan).

% let's make sure michael doesn't get pam or oscar
:- match(michael, (pam; oscar)).

% let's make sure creed doesn't get meredith
:- match(creed, meredith).
