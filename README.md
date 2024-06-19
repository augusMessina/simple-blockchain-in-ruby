# Blockchain Simulation on Ruby

This program will create a web server simulating a Blockchain node. From this server you can add transactions and mine blocks. On an ideal scenario, the program should be ran on different machines, obtaining a decentralized network.

## Requirements

For executing the program it is necessary to habe Ruby and Bundle installed.

## Run it

In order to run the program, you will have to use this command the first time, which will install all the dependencies:

```
bundle install
```

Once installed, the program can be executed with:

```
bundle exec ruby blockchain.rb
```

## Endpoints
The endpoints provided by the web server are:

#### `/chain`

GET endpoint, returns the chain stored in the node.

#### `/transactions`

GET endpoint, returns the pending transactions of the node.

#### `/newTransactions`

POST endpoint, adds a transaction to the pending transactions list. The format of a transaction is the following:

```
{
    "from": "sender",
    "to": "receiver",
    "what": "currency",
    "qty": quantity
}
```

#### `/mine`

POST endpoint, mines a new block with the pending transactions, adding a little reward in the transactions list to the mining node.

#### `/nodes/register`

POST endpoint, adds new nodes to the neighbour nodes list of the node. The format of the request body is:

```
{
    "nodes":[
        "NodeIP:NodePort"
    ]
}
```

#### `/nodes/resolve`

GET endpoint, updates the chain stored in the node by searching for better chains in neighbour nodes

---

# Simulación de Blockchain en Ruby

Con este programa se levantará un servidor web a modo de nodo de Blockchain, desde el que se podrán añadir transacciones y minar bloques. En una simulación ideal, se deberá correr este programa en distintas direcciones, consiguiendo así una red descentralizada.

## Prerrequisitos

Para correr este programa es necesario tener instalado tanto Ruby como Bundle, para poder interactuar con las Ruby Gems.

```
sudo apt-get install ruby-full

sudo gem install bundler
```

## Run it

Para correr el programa, si es la primera vez que se ejecuta, habrá que ejecutar el siguiente comando:

```
bundle install
```

Con dicho comando instalaremos las Ruby Gems necesarias. Para correr el programa, ejecutaremos:

```
sudo bundle exec ruby blockchain.rb
```

## Endpoints

Al correr el programa, se levantarán los siguientes endpoints:

- /chain: endpoint GET que devuelve la cadena del nodo.
- /transactions: endpoint GET que devuelve las transacciones pendientes del nodo.
- /newTransactions: endpoint POST que añade una transacción al array de transacciones pendientes. Se debe enviar con el siguiente formato:

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
