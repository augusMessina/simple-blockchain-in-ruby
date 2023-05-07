# Simulación de Blockchain en Ruby

Con este programa se levantará un servidor web a modo de nodo de Blockchain, desde el que se podrán añadir transacciones y minar bloques. En una simulación ideal, se deberá correr este programa en distintas direcciones, consiguiendo así una red descentralizada.

# Prerrequisitos

Para correr este programa es necesario tener instalado tanto Ruby como Bundle, para poder interactuar con las Ruby Gems.

```
sudo apt-get install ruby-full

sudo gem install bundler
```

# Run it

Para correr el programa, si es la primera vez que se ejecuta, habrá que ejecutar el siguiente comando:

```
bundle install
```

Con dicho comando instalaremos las Ruby Gems necesarias. Para correr el programa, ejecutaremos:

```
sudo bundle exec ruby blockchain.rb
```

# Endpoints

Al correr el programa, se lecantarán los siguientes endpoints:

- /chain: enpoint GET que devuelve la cadena del nodo.
- /transactions: enpoint GET que devuelve las transacciones pendientes del nodo.
- /newTransactions: enpoint POST que añade una transacción al array de transacciones pendientes. Se debe enviar con el siguiente formato:

```
{
    "from": "remitente",
    "to": "destinatario",
    "what": "divisa",
    "qty": cantidad
}
```

- /mine: endpoint POST que crea un nuevo bloque a partir de las transacciones pendientes.
- /nodes/register: endpoint POST que añade nuevos nodos al array de nodos vecinos. Se utiliza el siguiente formato:

```
{
    "nodes":[
        "IPDelNodo:Puerto"
    ]
}
```

- /nodes/resolve: endpoint GET que intenta actualizar la cadena del nodo buscando mejores cadenas en los nodos vecinos.
