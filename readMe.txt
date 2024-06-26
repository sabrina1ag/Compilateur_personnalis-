
Je souhaite attirer votre attention sur une petite erreur relative aux expressions arithmétiques concernant les signes + et -. Il est nécessaire d'insérer des espaces entre l'opérateur et les opérandes. Sans ces espaces, l'analyseur lexical pourrait identifier incorrectement l'entité comme un entier signé, même s'il ne l'est pas.
Par exemple, dans l'expression "1+2", l'analyseur interprétera "1" comme un entier et "+2" comme un entier signé, ce qui n'est pas le résultat souhaité.

À part cela, tout le programme fonctionne correctement.


//
pour executer le compilateur , aprés avoir executer votre commandes.bat.

le_nom_du_executable espace le_nom_de_l'exemple


--- par exemple --- :

compil.exe exemple.txt
//