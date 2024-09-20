# Wanderwege

Vorraussetzungen
Python 3.12.2

Wir benutzen Conda um Installation, Aktualisierung und Verwaltung von Softwarepaketen sowie Abhängigkeiten sauber zu trennen. 

https://conda.io/projects/conda/en/latest/user-guide/install/index.html

Danach kann die neue Umgebung (www) mit allen benötigten Bibliotheken angelegt werden indem die Datei environment.yaml ausgeführt wird:

conda env create -f environment.yaml

Damit der Zugriff auf die Azure Cloud funktioniert muss das das db_config.json File im Ordner Wanderwege/config abgelegt werden. Zudem muss auf Azure die IP des Benutzers hinterlegt werden

